setup:
	which heroku || (brew tap heroku/brew && brew install heroku)
	which pipenv || brew install pipenv
	pipenv sync
