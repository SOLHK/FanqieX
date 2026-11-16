"""Reject mixed-commit or modified Apple artifacts before byte-level audits."""
import json
from pathlib import Path
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
from verify162 import digest, validated_xcode_bundle


class XcodeArtifactTests(unittest.TestCase):
    VERSION = '1.78'

    def fixture(self, folder):
        candidate = Path(folder) / f'FanqieX-{self.VERSION}.dylib'
        # This test isolates provenance validation. Real Mach-O, assembly and
        # unwind checks remain separate mandatory verify162.py audit steps.
        candidate.write_bytes(b'provenance test candidate')
        for suffix in ('.composed.s', '.preextend', '.extension.bin'):
            candidate.with_suffix(suffix).write_bytes(suffix.encode())
        validation = {'version': self.VERSION, 'candidate_sha256': digest(candidate),
                      'native_unwind': {'passed': True}}
        report = {
            'plugin_version': self.VERSION, 'candidate_sha256': digest(candidate),
            'passed': True, 'two_builds_identical': True,
            'github_sha': 'a' * 40, 'xcode': 'Xcode 27.2\nBuild version test',
            'sdk_version': '27.2',
            'composed_assembly_sha256': digest(candidate.with_suffix('.composed.s')),
            'audit_input_sha256': {
                suffix: digest(candidate.with_suffix(suffix))
                for suffix in ('.preextend', '.extension.bin')},
            'native_source_sha256': {
                path: digest(ROOT / path)
                for path in ('native/AlignedGlass.m', 'native/FanqieXDiagnostics.m')},
        }
        candidate.with_suffix('.validation.json').write_text(json.dumps(validation))
        (candidate.parent / 'xcode-build-report.json').write_text(json.dumps(report))
        return candidate, validation, report

    def test_complete_same_commit_artifact_is_accepted(self):
        with tempfile.TemporaryDirectory() as folder:
            candidate, _, _ = self.fixture(folder)
            validation, composed, report = validated_xcode_bundle(candidate, self.VERSION, 'a' * 40)
            self.assertEqual(validation, candidate.with_suffix('.validation.json'))
            self.assertEqual(composed, candidate.with_suffix('.composed.s'))
            self.assertEqual(report, candidate.parent / 'xcode-build-report.json')

    def test_modified_or_incomplete_artifacts_are_rejected(self):
        for suffix in ('.dylib', '.validation.json', '.composed.s', '.preextend', '.extension.bin'):
            with self.subTest(file=suffix), tempfile.TemporaryDirectory() as folder:
                candidate, _, _ = self.fixture(folder)
                candidate.with_suffix(suffix).unlink()
                with self.assertRaises(RuntimeError):
                    validated_xcode_bundle(candidate, self.VERSION, 'a' * 40)
        for suffix in ('.dylib', '.composed.s', '.preextend', '.extension.bin'):
            with self.subTest(modified=suffix), tempfile.TemporaryDirectory() as folder:
                candidate, _, _ = self.fixture(folder)
                path = candidate.with_suffix(suffix)
                path.write_bytes(path.read_bytes() + b'modified')
                with self.assertRaises(RuntimeError):
                    validated_xcode_bundle(candidate, self.VERSION, 'a' * 40)

    def test_foreign_or_failed_reports_are_rejected(self):
        mutations = {
            'commit': {'github_sha': 'b' * 40},
            'version': {'plugin_version': '1.76'},
            'toolchain': {'xcode': 'Xcode 26.2'},
            'sdk': {'sdk_version': '26.2'},
            'failed': {'passed': False},
            'not reproducible': {'two_builds_identical': False},
            'source': {'native_source_sha256': {}},
            'candidate': {'candidate_sha256': '0' * 64},
        }
        for name, mutation in mutations.items():
            with self.subTest(case=name), tempfile.TemporaryDirectory() as folder:
                candidate, _, report = self.fixture(folder)
                report.update(mutation)
                (candidate.parent / 'xcode-build-report.json').write_text(json.dumps(report))
                with self.assertRaises(RuntimeError):
                    validated_xcode_bundle(candidate, self.VERSION, 'a' * 40)
        with tempfile.TemporaryDirectory() as folder:
            candidate, validation, _ = self.fixture(folder)
            validation['native_unwind']['passed'] = False
            candidate.with_suffix('.validation.json').write_text(json.dumps(validation))
            with self.assertRaises(RuntimeError):
                validated_xcode_bundle(candidate, self.VERSION, 'a' * 40)


class XcodeR2ArtifactTests(XcodeArtifactTests):
    VERSION = '1.78R2'

    def test_previous_release_metadata_cannot_be_renamed_to_r2(self):
        with tempfile.TemporaryDirectory() as folder:
            candidate, validation, report = self.fixture(folder)
            validation['version'] = '1.78'
            report['plugin_version'] = '1.78'
            candidate.with_suffix('.validation.json').write_text(json.dumps(validation))
            (candidate.parent / 'xcode-build-report.json').write_text(json.dumps(report))
            with self.assertRaises(RuntimeError):
                validated_xcode_bundle(candidate, self.VERSION, 'a' * 40)


class XcodeR3ArtifactTests(XcodeArtifactTests):
    VERSION = '1.78R3'

    def test_previous_candidate_metadata_cannot_be_renamed_to_r3(self):
        with tempfile.TemporaryDirectory() as folder:
            candidate, validation, report = self.fixture(folder)
            validation['version'] = '1.78R2'
            report['plugin_version'] = '1.78R2'
            candidate.with_suffix('.validation.json').write_text(json.dumps(validation))
            (candidate.parent / 'xcode-build-report.json').write_text(json.dumps(report))
            with self.assertRaises(RuntimeError):
                validated_xcode_bundle(candidate, self.VERSION, 'a' * 40)


if __name__ == '__main__':
    unittest.main()
