# TranslateAI
Export text from Adobe Illustrator files, send to machine translation services and re-import.

## Installation (Windows)
### Download the code

Click on the blue **Code** box, then Download source code: **zip**. (If you're familiar with Git you can also just clone the repo instead.)

![Zip file](img/DownloadZip.PNG)

Extract the folder from the zip file – you can put it anywhere on your computer at this stage.

Open the extracted folder, find the TranslateAI folder, and inside it the Process subfolder. Put the `config.json` file into the Process folder.

![ConfigJSON](img/configJSON.PNG)

Copy the TranslateAI folder into your Adobe Illustrator Scripts folder. The location will be something like:

`C:\Program Files\Adobe\Adobe Illustrator 202X\Presets\[language]\Scripts`

NOTE: You will need an admin password to do this.

![ConfigJSON](img/ScriptsFolder.PNG)

When the TranslateAI folder is inside the Scripts folder, the translation script is installed. You will need to restart Illustrator to use it.

### Running the script 

#### Install Python

If you don't already have Python installed, you will need to download it from the AFP app portal.

You will also need to install the `requests` Python module.

When Python is installed, open the Windows command prompt and type:

`pip install requests`

Then hit Enter to install.

#### Translate a graphic document

Open the graphic document you wish to translate. 

If you haven't already done so: Save your work! (Sometimes the script makes Illustrator crash)

Click: `File > Scripts > TranslateAi > Export`

![TranslateExport](img/TranslateExport.PNG)

You should see a message telling you that text was exported.
 Click **OK**.

![ClickOK](img/StartTranslation.PNG)

You will see a command prompt window open, while the translation script communicates with the AFP translate API. 

Wait for the text that says "Translation successful"

![Successful](img/TranslationSuccessful.PNG)

Click `File > Scripts > TranslateAi > Import` to place the translated text into the graphic document.

Sometimes you will see a message that says "Translate API returned no text." 

When this happens, try running the TranslateAi > Export script again from Illustrator.

![NoText](img/NoText.PNG)

## Installation (Mac)

*NOTE: You will need to have administrator permissions on your machine to install the scripts.*

### Make command script executable 

For the translate function to work, the `translate.command` script must be made into an **executable file**. To do this you must run the "change mode" command, `chmod`, from terminal, with administrator permissions.

1) Open the Terminal application on your Mac

2) Type `chmod +x ` (make sure to press space once after `x`)

![chmod](img/chmod.png)

3) Click on the `translate.command` file in your Scripts folder, and drag it into the terminal window. You should now see the file location in the terminal after the `chmod` command.

![chmod file](img/chmodfilepath.png)

4) Press enter. You should be prompted for your admin password. Type it in and hit enter. (You won't get any confirmation that it worked, but if the terminal starts a new line you're good.)

### Place scripts into Illustrator script folder

To run scripts from the **File > Scripts** menu in Illustrator, they must be placed in your **Scripts** directory.

The location should be something like:

> Applications > Adobe Illustrator {version_number} > Presets > {language} > Scripts

![Mac filepath](img/macfilepath.png)

First make sure Illustrator is closed. Then move the `TranslateAi` folder into your Scripts directory.

You will be prompted to enter your password to do this.

### Allow apps from anywhere

Lastly, you'll need to configure your sytem to run software downloaded from outside of the App Store.

Go to:
> System Preferences > Security & Privacy > General

And select "Allow apps downloaded from: Anywhere"

![software anywhere](img/anywhere.jpg)

Now the tool should be ready to run.