"""Quellstruktur und GTK-/PNG-Ressourcen prüfen; kein Spieltest."""
from pathlib import Path
import xml.etree.ElementTree as ET

root = Path(__file__).resolve().parents[1]
workspace = root / 'Hive_Workspace'
assert (workspace / 'hive.gpr').is_file(), 'GPR-Projekt fehlt'
assert (workspace / 'src/mainhive.adb').is_file(), 'Ada-Einstieg fehlt'
sources = list((workspace / 'src').rglob('*.ad?'))
assert sources and all(p.stat().st_size for p in sources), 'Leerer Ada-Quellstand'
tree = ET.parse(workspace / 'src/View/Hive.glade')
assert tree.getroot().tag == 'interface', 'Ungültige Glade-Oberfläche'
images = list((workspace / 'resource').glob('*.png'))
assert images and all(p.read_bytes().startswith(b'\x89PNG\r\n\x1a\n') for p in images), 'PNG-Ressourcen fehlen oder sind beschädigt'
ET.parse(root / 'docs/assets/hero.svg')
print(f'Integrität OK: {len(sources)} Ada-Dateien, {len(images)} PNG-Ressourcen und Glade-XML.')
