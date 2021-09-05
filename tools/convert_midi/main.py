import argparse
import pathlib
import sys
from mido import MidiFile

HELP_MAIN = 'Convert MIDI file into a useful format for EasyRhythm game.'
HELP_FILEPATH = 'filepath of the midi file to convert'

parser = argparse.ArgumentParser(description=HELP_MAIN)
parser.add_argument('filepath', help=HELP_FILEPATH, type=pathlib.Path)
args = parser.parse_args()
filepath = args.filepath

print(args.filepath, type(args.filepath))

try:
	mid = MidiFile(filepath)
	print(mid)
except Exception as e:
	print(f'Error while parsing the midi file.\nMIDO Error: {e}', file=sys.stderr)

