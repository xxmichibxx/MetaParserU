<h3 align="center">MetaParserU</h3>
<p align="center"><img href="https://github.com/xxmichibxx/MetaParserU" src="https://i.imgur.com/gNuy8WR.png" alt="Logo" width="80" height="80"></p>
<h3 align="center">A batch for parsing the meta.xml file from decrypted Nintendo Wii U titles.</h3>
<hr>

![GitHub Release](https://img.shields.io/github/v/release/xxmichibxx/MetaParserU) ![Downloads](https://img.shields.io/github/downloads/xxmichibxx/MetaParserU/total) ![Issues](https://img.shields.io/github/issues/xxmichibxx/MetaParserU)

## Features
The batch displays:
* the full title name
* the product code (e.g. WUP-P-AECD)
* the Loadiine ID (e.g. AECD52)
* the full title ID (e.g. 00050000-10113700)
* the title version (e.g. v144)
* the region of the title (USA/EUR/JPN/RF)
* the mastering date if set (e.g. 2012-10-16 14:26:29)
* the title type (e.g. Game/Game [vWii]/DLC/Update Data/Virtual Console/System App)
* the name from the publisher (e.g. Activision Publishing, Inc.)
* if the title is a Retail only title or from the Nintendo Update Server (NUS)
* if the title is using the Network feature (No/Yes [Optional]/Yes [Required])
* if the title is using the Nintendo Network ID feature (No/Yes [Optional]/Yes [Required])
* if the title is using the Gamepad feature (No/Yes [Normal]/Yes [Mirrored only])
* if the title is hidden or launchable via the Wii U home menu

## Usage
Drag & Drop your meta.xml or the folder from your Wii U title into the "MetaParserU.bat". Valid options are:
* The meta.xml file itself
* A folder including the meta.xml e.g. ```meta\meta.xml```
* A folder including the whole Wii U title folder e.g. ```Call of Duty Black Ops 2 [AECD52]\meta\meta.xml```

You can also run the batch via command line e.g. ```MetaParserU.bat "C:\Call of Duty Black Ops 2 [AECD52]\meta\meta.xml"```.

## Supported operating systems
* Windows XP (x86/x64) or higher
* Windows Server 2003 (x86/x64) or higher

## Notes
* WUX/WUP files are not supported. These must first be extracted and decrypted.
* For proper drag-and-drop, the title folder needs to be in the Loadiine or CEMU format.
* It's not possible to run the batch directly. The batch always needs a parameter.
* The batch runs under Windows 2000, but due to codepage issues, it's not recommended.
* Japanese characters in folder names are not supported. Please drag and drop only the meta.xml file.
