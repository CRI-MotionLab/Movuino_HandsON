# Applications

Download link for Movuino desktop interface:
* WINDOWS: https://drive.google.com/file/d/0B2oVfPg1m1UmQmNSM041bGdTTDg/view?usp=sharing
* MAC OSX: https://drive.google.com/file/d/0B2oVfPg1m1UmY0FvQVhTWUxhRnM/view?usp=sharing
  * /!!\ You should get an error message saying the file is damaged: go to (your Mac) System Preferences / Security and confidentiality and choose "Allow downloaded applications from anywhere". Re-open the file and say that you want to open it (don't be afraid, the file is safe). Once it's done you can set your preferences to the previous ones.
  * If the Allow option is not available (default case on latest Mac), you need to open the Terminal application and type the command `sudo spctl --master-disable`

# Max patch file

Movuino Interface is made with Max/MSP, you can run the original patch or a maxcollective file.
To run all the functionnalities you will also need to install the Mubu For Max package.

MuBu is a Max/MSP package developed by IRCAM. It gives Max objects to easily store and manage data flows.
* Presentation: https://www.julesfrancoise.com/mubu-probabilistic-models/
* Download link: http://forumnet.ircam.fr/fr/produit/mubu/
* References (2012): http://forumnet.ircam.fr/wp-content/uploads/2012/10/MuBu-for-Max-Reference.pdf
* Discussion forum: http://forumnet.ircam.fr/user-groups/mubu-for-max/forum/

### Installation : Max/MSP + MubuForMax  
* download and install Max/MSP: https://cycling74.com/downloads
* download the package on the MuBu page: http://forumnet.ircam.fr/fr/produit/mubu/
* unzip the folder "MuBuForMax" and simply past it into the proper folder:
  * **On Macintosh**
    * go to Applications folder, right click on the **Max** icon and choose "Show Package Contents"
    * paste the MuBuForMax folder into Contents/Resources/C74/packages
    * launch or restart Max and that's it.
   * **On Windows**
     * paste the MuBuForMax folder into /Documents/Max 7/Packages (or in the installation folder in \Max 7\resources\packages)
     * launch or restart Max and that's it.
 * Then run the **MovuinoInterface_MaxCollective.mxf** file
 * **Bonus**: original MAX/MSP project files https://dl.dropboxusercontent.com/u/22837472/MOVUINO/Movuino_Interface_Project.zip
