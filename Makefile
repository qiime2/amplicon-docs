autodoc:
	cd docs/references && q2doc autodoc --no-validate .

html:
	cd docs && jupyter book build --html
	cp -r docs/data/ docs/_build/html/data/

fast-preview:
	cd docs && Q2DOC_FASTMODE= jupyter book build --html
	cp -r docs/data/ docs/_build/html/data/

preview:
	cd docs && Q2DOC_PREVIEW= jupyter book build --html
	cp -r docs/data/ docs/_build/html/data/

serve:
	npx serve docs/_build/html/ -p 4000

clean:
	rm -rf docs/_build/html/