PYTHON = python2.7


all: ve/bin/py.test

ve:
	virtualenv -p $(PYTHON) ve
	ve/bin/pip install -e .[test]

ve/bin/py.test: ve setup.py
	ve/bin/pip install pytest pytest-cov
	touch ve/bin/py.test

.PHONY: test
test: ve/bin/py.test
	ve/bin/py.test \
	    --cov=src --cov-report=term-missing --cov-report=html \
	    -s --tb=native -rw \
	    src

clean:
	rm -rvf bin src/*.egg-info .installed.cfg parts ve
