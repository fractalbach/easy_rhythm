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



def note_num_to_game_key(note):
	"""Converts MIDI note number into a number between 0 and 7,
	which corresponds to the key that will be used in the game."""
	d, m = divmod(note, 12)

	# Special case for C and C#.
	# They split between key 0 and 7 based on octave.
	if m < 2:
		if d < 7:
			return 0
		else:
			return 7

	# Remaining cases are more simply determined.
	elif m < 3:  return 1 # D
	elif m < 5:  return 2 # Eb and E
	elif m < 7:  return 3 # F and F#
	elif m < 9:  return 4 # G and G#
	elif m < 11: return 5 # A and A#
	elif m < 12: return 6 # B
	return -1 # Error case.


if __name__ == '__main__':
	main()
