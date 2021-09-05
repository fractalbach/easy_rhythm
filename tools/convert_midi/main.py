import argparse
import pathlib
import sys
from mido import MidiFile

HELP_MAIN = 'Convert MIDI file into a useful format for EasyRhythm game.'
HELP_FILEPATH = 'filepath of the midi file to convert'


def main():
	parser = argparse.ArgumentParser(description=HELP_MAIN)
	parser.add_argument('filepath', help=HELP_FILEPATH, type=pathlib.Path)
	args = parser.parse_args()
	filepath = args.filepath
	try:
		parse(filepath)
	except Exception as e:
		print(f'Error while parsing the midi file.\nMIDO Error: {e}', file=sys.stderr)


def parse(filepath):
	time = 0
	midi = MidiFile(filepath)
	for track in midi.tracks:
		for message in track:
			time = handle_message(message, time)


def handle_message(message, time):
	if not message.is_meta:
		if message.type =='note_on' or message.type == 'note_off':
			mtype = message.type[5:].upper()
			print(f'{time:6d} : {mtype:3s} : {message.note}')
	return time + message.time


if __name__ == '__main__':
	main()