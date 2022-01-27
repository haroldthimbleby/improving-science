All data and files for the paper "Computational science reviewed: A (fixable) failure of software~engineering"

Harold Thimbleby

harold@thimbleby.net

27 January 2022

All data is defined and stored in human-readable JSON format in the file `data.js`

`data.js` also includes a JavaScript program that checks the JSON data, analyses it and generates various files.

If you just want all the data in various formats, please run

    node data.js

this will give you

        allData.csv - for accessing data in Excel and many other apps
        flagData.nb - for accessing data in Mathematica notebook
        data-check.html - a summary of papers and DOIs with any error messages (eg missing data), for easy review in a browser
    ...plus a few tex files for including data in Latex files
    It will list all files generated and their purpose

***

The makefile will do everything for you. 

For example, "make config" will tell you what software you need to run everything.

Run "make help" to see everything that you can do
        
***

For help or further information, please email <harold@thimbleby.net>


