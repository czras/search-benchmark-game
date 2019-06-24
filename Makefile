CORPUS = $(PWD)/corpus.json
export

CORPUS_URL = https://www.dropbox.com/s/wwnfnu441w1ec9p/wiki-articles.json.bz2?dl=0
COMMANDS = COUNT NO_SCORE TOP_10 # not used anymore in client.py
ENGINES = `ls engines`

all: index

corpus.json.bz2:
	wget $(CORPUS_URL) -O corpus.json.bz2

corpus.json: corpus.json.bz2
	bunzip2 $(CORPUS).bz2

corpus: corpus.json

clean:
	rm -f results.json
	for engine in $(ENGINES); do cd $(PWD)/engines/$$engine && make clean ; done

# Target to build the indexes of
# all of the search engine
index: $(INDEX_DIRECTORIES)
	for engine in $(ENGINES); do cd $(PWD)/engines/$$engine && make index ; done

compile:
	for engine in $(ENGINES); do cd $(PWD)/engines/$$engine && make compile ; done

# Target to run the query benchmark for
# all of the search engines
bench: #index compile
	@rm -f results.json
	python3 src/client.py queries.txt $(ENGINES)

serve:
	cd web/output && python -m SimpleHTTPServer 8000
