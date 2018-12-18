# Movuino to Python

This template shows how to communicate with the Movuino using OSC protocole. You can receive the data and send back message to the Movuino.

## Installation
* Download and install Python 2.7
  * If you're on **Windows**, add Python into System Environment Variables: https://docs.python.org/2/using/windows.html#excursus-setting-environment-variables
* Download and install Python libraries: a good way to install Python libraries is to use pip command into your terminal, download and see how to install it here: https://pip.pypa.io/en/stable/installing/ 
  * Install pip
    * copy the file `get-pip.py` into your Python libraries folder and run the command `python get-pip.py` inside this folder
    * on Windows, add the folder `C:\[pythondir]\scripts` into your `System Environment Variables`
  * pyOSC: this one is not available with `pip` command, you have to install it manually
    * Download here: https://github.com/ptone/pyosc (or https://pypi.python.org/pypi/pyOSC -> not tested!)
    * Unzip the folder and paste it into your Python libraries folder.
      * On Macintosh: /Library/Python/2.7/site-packages
      * On Windows: C:\Python27\Lib\site-packages
    * Open the command line console and change directory to the Python "site-packages" (previous point)
      * Macintosh: `cd /Library/Python/2.7/site-packages/pyOSC-0.3.5b_5294-py2.7.egg-info`
      * Windows: `cd C:\Python27\Lib\site-packages\pyOSC-0.3.5b_5294-py2.7.egg-info`
    * Now install the library with the command `python setup install`. You may need to run the command as administrator.
    * Reference: https://wiki.labomedia.org/index.php/Envoyer_et_recevoir_de_l'OSC_en_python
    
Go into the Main.py file and `main()` function of OSC_communication.py script to see how to interact with the code.  

#### Note
The pyOSC library returns an error when you close the server thread (`self.s.close()`). This error is not really a problem since the thread is actually closed once called. If you know how to handle it please tell me cause I don't know when I will check that.
