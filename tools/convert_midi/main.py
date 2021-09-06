import argparse
import pathlib
import sys
from pprint import pprint
from mido import MidiFile


HELP_MAIN = 'Convert MIDI file into a useful format for EasyRhythm game.'
HELP_FILEPATH = 'filepath of the midi file to convert'


def main():
	parser = argparse.ArgumentParser(description=HELP_MAIN)
	parser.add_argument('filepath', help=HELP_FILEPATH, type=pathlib.Path)
	args = parser.parse_args()
	filepath = args.filepath
	try:
		converter = Converter(filepath)
		converter.display()
	except Exception as e:
		print(f'Error while parsing the midi file.\nMIDO Error: {e}', file=sys.stderr)


class Converter():
	def __init__(self, filepath):
		self.note_counter = {}
		self.time = 0
		self.output = ''
		midi = MidiFile(filepath)
		for track in midi.tracks:
			for message in track:
				self.handle_message(message)


	def handle_message(self, message):
		if message.is_meta:
			print(message)
		if not message.is_meta:
			if message.type =='note_on' or message.type == 'note_off':
				mtype = message.type[5:].upper()
				self.output += f'{self.time:6d} : {mtype:3s} : {message.note}'
				self.count_note(message.note)
		self.time += message.time


	def count_note(self, note):
		if not note in self.note_counter:
			self.note_counter[note] = 1
		else:
			self.note_counter[note] += 1


	def display(self):
		pprint(self.note_counter)
		

if __name__ == '__main__':
	main()
