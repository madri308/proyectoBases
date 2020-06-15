for %%G in (*.sql) do sqlcmd /S . /d Progra -E -i"%%G"
pause