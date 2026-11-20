"""Execute candidate hooks at the inspected host's shelf model/layout boundaries.

Host evidence: Reading 7.4.3.33 updateLabelWithModel: at 0x10d504974 creates
zoom animation blocks; updateLayoutWithModel: at 0x10d505208 remakes constraints
using anchor style and normal/selected zoom ratios. UIKit remains a boundary.
"""
import argparse
import copy
import json
import struct
from pathlib import Path

from arm64 import require, release_version
from test_control_glass166 import send
from test_feed_viewport import labels_for
from test_home_glass165 import LABELS
from test_page_glass174 import Runtime as PageRuntime, make

CELL="SSBookShelfTabSelectViewTitleCell"
MODEL="SSBookShelfTabSelectViewTitleCellModel"
VIEW="SSBookShelfTabSelectView"
CATEGORY="FQRJXCategoryBaseView"
WILL_DISPLAY="collectionView:willDisplayCell:forItemAtIndexPath:"
FILTER="SSBookShelfFilter541Cell"
DOUBLES=("titleLabelNormalZoomScale","titleLabelCurrentZoomScale","titleLabelSelectedZoomScale",
         "titleLabelVerticalOffset","titleLabelZoomSelectedVerticalOffset")
BOOLS=("titleLabelZoomEnabled","selectedAnimationEnabled","titleLabelStrokeWidthEnabled")
METHODS=(
 (CELL,"updateLabelWithModel:","v24@0:8@16"),
 (CELL,"updateLayoutWithModel:","v24@0:8@16"),
 (VIEW,"refreshCellModel:index:","v32@0:8@16q24"),
 (VIEW,"refreshSelectedCellModel:unselectedCellModel:","v32@0:8@16@24"),
 (VIEW,"refreshLeftCellModel:rightCellModel:ratio:","v40@0:8@16@24d32"),
 (FILTER,"fontForSelectState:","@20@0:8B16"))
WIDTH=(VIEW,"preferredCellWidthAtIndex:","d24@0:8q16")


class Runtime(PageRuntime):
    PROPERTY=0x330f1000
    def __init__(self,data):
        super().__init__(data)
        self._class(CATEGORY,"UIView")
        self._class(VIEW,CATEGORY)
        self.original_will_display=0x330f1800
        self._add(self.classes[CATEGORY],WILL_DISPLAY,self.original_will_display,"v40@0:8@16@24@32")
        self.fitted_title_containers=0
        self.native_display_calls=[]
        self.properties={}
        self.host_entries={}
        self.consumed=[]
        self.shelf_calls=[]
        for key,kind in [(x,"d") for x in DOUBLES]+[(x,"B") for x in BOOLS]+[
                ("titleLabelAnchorPointStyle","Q"),("titleFont","@"),("titleSelectedFont","@")]:
            getter="is"+key[0].upper()+key[1:] if kind=="B" else key
            setter="set"+key[0].upper()+key[1:]+":"
            self.properties[getter]=(key,kind,False)
            self.properties[setter]=(key,kind,True)
            self._add(self.classes[MODEL],getter,self.PROPERTY,kind+"16@0:8")
            self._add(self.classes[MODEL],setter,self.PROPERTY,"v"+("20" if kind=="B" else "24")+"@0:8"+kind+"16")
        for i,(cls,sel,abi) in enumerate(METHODS+(WIDTH,(CELL,"reloadData:","v24@0:8@16"))):
            imp=0x330f2000+i*0x100
            self.host_entries[imp]=(cls,sel)
            self._add(self.classes[cls],sel,imp,abi)

    def handle(self,c,pc):
        obj=c.x[0]
        if pc-self.slide==0xa5d4 and self.selector_names.get(c.x[1])=="setTransform:" and obj in self.objects:
            self.objects[obj].state["transform"]=struct.unpack("<6d",bytes(c.read(c.x[2]+i,1) for i in range(48)))
            return self.finish(c)
        if pc==self.original_will_display:
            self.native_display_calls.append(tuple(c.x[:5]))
            return self.finish(c)
        if pc-self.slide==0xa5d4 and obj in self.objects:
            state=self.objects[obj].state
            name=self.selector_names.get(c.x[1])
            if name=="titleContainerView" and "titleContainerView" in state:
                return self.finish(c,state["titleContainerView"])
            if name=="layoutIfNeeded" and state.get("pendingTitles"):
                self.fitted_title_containers+=1
                for label in state.pop("pendingTitles"):
                    self.objects[label].state.update(frame=(0.,0.,34.,34.),bounds=(0.,0.,34.,34.),textAlignment=0)
                return self.finish(c)
        if pc==self.PROPERTY:
            key,kind,setter=self.properties[self.selector_names[c.x[1]]]
            state=self.objects[obj].state
            if setter:
                state[key]=c.fp(0) if kind=="d" else c.x[2]
                return self.finish(c)
            return self.finish(c,fp=(state[key],)) if kind=="d" else self.finish(c,state[key])
        if pc in self.host_entries:
            cls,sel=self.host_entries[pc]
            self.shelf_calls.append(sel)
            state=self.objects[obj].state
            if sel=="preferredCellWidthAtIndex:":
                return self.finish(c,fp=(34.,))
            if cls==FILTER:
                return self.finish(c,state["selectedFont"] if c.x[2] else state["textFont"])
            if sel=="refreshCellModel:index:":
                self.objects[c.x[2]].state.update(state["nativeStyle"])
                return self.finish(c)
            if sel.startswith("refreshSelected"):
                for model,selected in ((c.x[2],True),(c.x[3],False)):
                    st=self.objects[model].state
                    st.update(isSelected=selected,titleCurrentColor="selected" if selected else "normal",
                              titleLabelCurrentZoomScale=1.25 if selected else 1.)
                return self.finish(c)
            if sel.startswith("refreshLeft"):
                self.objects[c.x[2]].state["titleLabelCurrentZoomScale"]=1.+0.25*(1-c.fp(0))
                self.objects[c.x[3]].state["titleLabelCurrentZoomScale"]=1.+0.25*c.fp(0)
                return self.finish(c)
            model=c.x[2]
            state["cellModel"]=model
            m=self.objects[model].state
            self.consumed.append(copy.copy(m))
            # Explicit boundary for the two disassembled native consumers. Their
            # inputs, rather than only the plugin's later rectangle, are checked.
            for key in ("titleLabel","maskTitleLabel"):
                st=self.objects[state[key]].state
                font=m["titleSelectedFont"] if m.get("isSelected") else m["titleFont"]
                st["font"]=font
                if m["titleLabelZoomEnabled"]:
                    scale=m["titleLabelCurrentZoomScale"]
                    st["transform"]=(scale,0.,0.,scale,0.,0.)
                offset=m["titleLabelVerticalOffset"]+m["titleLabelZoomSelectedVerticalOffset"] if m["titleLabelAnchorPointStyle"] else m["titleLabelVerticalOffset"]
                st["frame"]=(0.,offset,34.,34.)
                st["bounds"]=(0.,0.,34.,34.)
                st["textColor"]=m.get("titleCurrentColor","normal")
            return self.finish(c)
        return super().handle(c,pc)


def exercise(data,labels):
    c,r=make(data,Runtime);r.labels=labels
    c.run(labels["LFQH_FQHPageInstall"],max_steps=1500000)
    installed={(r.class_names[e["self"]],e["selector"]) for e in r.events if e["event"]=="method_setImplementation"}
    require(all((cls,sel) in installed for cls,sel,_ in METHODS),"Every inspected shelf transition boundary is installed")
    normal=r.obj("UIFont","native normal font",pointSize=18.,weight="regular")
    selected=r.obj("UIFont","native selected font",pointSize=21.,weight="semibold")
    native={"titleLabelZoomEnabled":1,"selectedAnimationEnabled":1,"titleLabelStrokeWidthEnabled":1,
            "titleLabelNormalZoomScale":1.,"titleLabelCurrentZoomScale":1.,"titleLabelSelectedZoomScale":1.25,
            "titleLabelVerticalOffset":-3.,"titleLabelZoomSelectedVerticalOffset":-5.,
            "titleLabelAnchorPointStyle":2,"titleFont":normal,"titleSelectedFont":selected}
    view=r.view(VIEW,"shelf title strip",(0,0,440,34),r.ROOT,nativeStyle=native)
    width=34.
    if release_version(data)=="1.78R12":
        require((VIEW,WIDTH[1]) in installed,"The exact native collection width hook is installed")
        send(c,r,view,WIDTH[1],0)
        require(c.fp(0)==46.,"Native layout reserves capsule padding, placing its first edge at the native 20pt inset")
        width=c.fp(0)
    models=[r.obj(MODEL,"title model",**native,isSelected=bool(i),cellSpacing=18.) for i in range(2)]
    cell=r.view(CELL,"圈子",(20,0,width,34),view,cellModel=models[0])
    for key in ("titleLabel","maskTitleLabel"):
        r.objects[cell].state[key]=r.label(key,cell,(0,-8,34,34),"圈子",alignment=0)
        r.objects[r.objects[cell].state[key]].state["transform"]=(1.,0.,0.,1.,0.,0.)
    for i,model in enumerate(models): send(c,r,view,"refreshCellModel:index:",model,i)
    if release_version(data) in ("1.78R15", "1.78R16", "1.78R17", "1.78R18", "1.78R25", "1.78R26", "1.78R27", "1.78R28", "1.78R29", "1.78R30", "1.78R31", "1.78R32", "1.78R33", "1.78R34", "1.78R35", "1.78R36", "1.79R1", "1.79R2", "1.79R3", "1.79R4", "1.79R5", "1.8R1", "1.8R2", "1.8R3", "1.8R4", "1.8R5", "1.8R6", "1.8R7", "1.8R8", "1.8R9", "1.8R10", "1.8R11", "1.8R12", "1.8R13", "1.8R14", "1.8R15", "1.8R16", "1.8R17", "1.8R18", "1.8R19", "1.8R19", "1.9.1beta1", "1.9.1beta2", "1.9.1beta3", "1.9.1beta4", "1.9.1beta5", "1.9.1beta6", "1.9.1beta7", "1.9.1beta8", "1.9.1beta9", "1.9.1beta10", "1.9.1beta11", "1.9.1beta12", "1.9.1beta13"):
        collection=r.view("UICollectionView","actual title collection",(0,0,440,34),view)
        r.objects[view].state["collectionView"]=collection
        first=r.view(CELL,"first frame before UIKit layout",(20,0,46,34),collection,cellModel=models[0],layout_passes=0)
        container=r.view("UIView","native inner title container",(0,0,46,34),first)
        labels_pending=[r.label(key,container,(0,0,34,34),"书架",alignment=0)
                        for key in ("titleLabel","maskTitleLabel")]
        for label in labels_pending:
            r.objects[label].state["transform"]=(1.,0.,0.,1.,0.,0.)
        r.objects[container].state["pendingTitles"]=labels_pending
        r.objects[first].state.update(titleContainerView=container,titleLabel=labels_pending[0],
                                      maskTitleLabel=labels_pending[1])
        send(c,r,view,WILL_DISPLAY,collection,first,0)
        require(len(r.native_display_calls)==1 and r.objects[first].state["layout_passes"]==1 and
                r.fitted_title_containers==1,"Book shelf willDisplay forwards once and resolves both pending title constraints")
        require(all(r.objects[label].state["frame"]==(6.,0.,34.,34.) and
                    r.objects[label].state["textAlignment"]==1 for label in labels_pending),
                "Both titles use the final 46pt cell center before any selection")
        require(r.methods[r.get_method(r.classes[CATEGORY],r.sel(WILL_DISPLAY))]["imp"]==r.original_will_display,
                "The inherited callback is untouched on other category owners")
    snapshots=[]
    for selected_index in (0,1,0,1):
        send(c,r,view,"refreshSelectedCellModel:unselectedCellModel:",models[selected_index],models[1-selected_index])
        for ratio in (0.,0.35,0.8,1.):
            send(c,r,view,"refreshLeftCellModel:rightCellModel:ratio:",*models,fp=(ratio,))
            for sel in ("reloadData:","updateLabelWithModel:","updateLayoutWithModel:"):
                send(c,r,cell,sel,models[0])
            surface=c.run(labels["LFQH_FQHSurface"],args=(cell,))["result"]
            snapshots.append((r.objects[surface].state["frame"],tuple(
                (r.objects[r.objects[cell].state[key]].state["frame"],
                 r.objects[r.objects[cell].state[key]].state["font"],
                 r.objects[r.objects[cell].state[key]].state["transform"])
                for key in ("titleLabel","maskTitleLabel"))))
    require(all(x==snapshots[0] for x in snapshots),"Click, swipe interpolation and late host layout cannot resize or move text/glass")
    require(snapshots[0][0]==((0.,2.,46.,30.) if width==46 else (-6.,2.,46.,30.)),
            "The collection width preserves title padding and R12's first glass begins at the native 20pt inset")
    for model in r.consumed:
        require(not any(model[k] for k in BOOLS) and all(model[k]==1 for k in DOUBLES[:3]) and
                model["titleLabelAnchorPointStyle"]==0 and model["titleLabelVerticalOffset"]==0 and
                model["titleLabelZoomSelectedVerticalOffset"]==0 and model["titleSelectedFont"]==normal,
                "Native animation/constraint consumers receive stable values before they run")
    require(r.objects[models[0]].state["titleCurrentColor"]=="normal","Native selection color remains authoritative")
    r.objects[r.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"]=1
    if release_version(data)=="1.78R12":
        send(c,r,view,WIDTH[1],0)
        require(c.fp(0)==34.,"Glass off restores the original native collection width")
    send(c,r,cell,"reloadData:",models[0])
    state=r.objects[models[0]].state
    require(all(state[k]==v for k,v in native.items()),"Disabling restores saved native fonts, zoom, anchor and offsets")
    require(not c.run(labels["LFQH_FQHSurface"],args=(cell,))["result"],"Disabling removes the shelf glass")
    send(c,r,view,"refreshSelectedCellModel:unselectedCellModel:",models[0],models[1])
    send(c,r,cell,"reloadData:",models[0])
    require(r.objects[r.objects[cell].state["titleLabel"]].state["transform"][0]==1.25,
            "The disabled native selected consumer creates its real zoom transform")
    r.objects[r.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"]=0
    send(c,r,cell,"updateLabelWithModel:",models[0])
    require(all(r.objects[r.objects[cell].state[key]].state["transform"]==(1.,0.,0.,1.,0.,0.)
                for key in ("titleLabel","maskTitleLabel")),
            "Re-enabling clears native zoom left by the non-zoom font branch")
    header=r.view("SSBookShelfFilterHeaderView","inline",(0,0,440,30),r.ROOT,clipsToBounds=True)
    row=r.view("SSBookShelfFilterMixRowCollectionView","row",(0,0,440,30),header,clipsToBounds=True)
    f=r.view(FILTER,"全部",(0,0,58,30),row,textFont=normal,selectedFont=selected,isSelect=True)
    label=r.label("filter",f,(7,3,38,20),"全部");r.objects[f].state["textLabel"]=label
    r.objects[r.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"]=0
    require(send(c,r,f,"fontForSelectState:",0)["result"]==send(c,r,f,"fontForSelectState:",1)["result"]==normal,
            "Inline filter selection uses one native font size")
    send(c,r,f,"layoutSubviews")
    surface=c.run(labels["LFQH_FQHSurface"],args=(f,))["result"]
    require(r.objects[surface].state["frame"]==(1.,1.,56.,28.),"Filter glass stays entirely inside its clipping row")
    cases=["six exact selection hooks","16 click/swipe cycles","late native label and constraint consumers",
           "collection title width and disabled native width",
           "selection color preserved","disable restores native state","filter font and clipping boundary"]
    if release_version(data)=="1.78R18":
        r.objects[r.WINDOW].state.update(frame=(0,0,440,956),bounds=(0,0,440,956))
        targets=[(header,r.sel("filterBtnClick"),64)]
        action=r.view("UIButton","Filter action",(362,0,66,30),header,control_targets=targets)
        fade=r.view("UIView","stock trailing fade",(332.5,0,24,30),header)
        header_state=r.objects[header].state
        header_state.update(filterButton=action,filterGradientView=fade)
        for left,expected in ((332.5,330.),(331.5,330.),(329.,329.)):
            header_state["host_filter_fade_frame"]=(left,0,24,30)
            send(c,r,header,"layoutSubviews")
            require(r.objects[fade].state["frame"]==(expected,0.,24.,30.),
                    "The stock fade clears the capsule's outer rim and retains its width")
        require(r.objects[action].state["frame"]==(355.,0.,66.,30.) and
                r.objects[action].state["control_targets"]==targets,
                "Clearing the rim preserves the capsule alignment and the native filter action")
        cases.append("filter action rim clearance and native target")
    r.objects[r.DEFAULTS].state["values"]["FanqieAdBlock.GlassDisabled.1"]=1
    require(send(c,r,f,"fontForSelectState:",1)["result"]==selected,"Disabled filter returns its native selected font")
    return {"passed":True,"device_tested":False,"host_binary_inspected":True,
            "host_methods":{"updateLabelWithModel:":"0x10d504974","updateLayoutWithModel:":"0x10d505208",
                            "fontForSelectState:":"0x10d4cad74"},
            "cases":cases,
            "limits":["Candidate ARM64 instructions execute; UIKit drawing and native constraint solver are modeled boundaries."]}


if __name__=="__main__":
    p=argparse.ArgumentParser();p.add_argument("candidate",type=Path);p.add_argument("--report",type=Path,required=True)
    a=p.parse_args();data=a.candidate.read_bytes()
    labels=labels_for(data,a.candidate.with_suffix(".composed.s"),LABELS+["LFQH_FQHPageInstall","LFQH_FQHSurface"])
    result=exercise(data,labels);a.report.write_text(json.dumps(result,ensure_ascii=False,indent=2)+"\n",encoding="utf8")
    print(json.dumps(result,ensure_ascii=False,indent=2))
