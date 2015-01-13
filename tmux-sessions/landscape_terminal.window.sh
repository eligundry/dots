new_window "landscape_terminal"
split_h 50
split_v 50
run_cmd "source $HOME/.virtualenvs/landscape-django/bin/activate; clear" 0
run_cmd "source $HOME/.virtualenvs/landscape-django/bin/activate; clear" 1
run_cmd "source $HOME/.virtualenvs/landscape-django/bin/activate; clear" 2
run_cmd "python manage.py runserver" 1
run_cmd "python manage.py shell" 2
select_pane 0
