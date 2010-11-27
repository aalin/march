default: main.o midi_input.o
	g++ -framework CoreMIDI -framework CoreFoundation -framework CoreServices -o midi_input main.o midi_input.o

main.o: main.cpp
	g++ -Wall -Wextra -c main.cpp

midi_input.o: midi_input.cpp midi_input.hpp
	g++ -Wall -Wextra -c midi_input.cpp

clean:
	rm -f *.o
