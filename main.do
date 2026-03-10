include "setup.do"

global results "${rootdir}/results"
cap mkdir "$results"

sysuse auto, clear

// testing python
python query
shell python -m venv ~/venv
shell ~/venv/bin/pip install -r requirements.txt
set python_exec "~/venv/bin/python"
python query

// test loading a module
python:
import numpy as np
import pandas as pd
end
// Expected output:
//. python:
//----------------------------------------------- python (type end to exit) ----------
//>>> import numpy as np
//>>> import pandas as pd
//>>> end
//------------------------------------------------------------------------------------
