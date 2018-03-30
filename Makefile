.PHONY = all demo

all:
	zip fruitninjabutwithgeese.love main.lua goose.png LICENSE

demo: all
	mv fruitninjabutwithgeese.love ~/fuse/android/Phone/Download
