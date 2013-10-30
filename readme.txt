 Alfresco Support Tools for the new Admin console in Alfresco 4.2
 ----------------------------------------------------------------

This add-on has been designed to work only in Alfresco Enterprise 4.2 using JDK7 and Tomcat7.
It probably won't work on Alfresco Community Edition due the lack of JMX connectivity.
From the client side has been tested to work with current versions of Firefox, IE and Chrome only. 


LICENSE:
// Copyright (c) 2013, Alfresco Software Ltd. October 2013
//
// Author: Antonio Soler, antonio.soler@alfresco.com
//
// Alfresco is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Alfresco is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// See <http://www.gnu.org/licenses/>.
//
// THIS SOFTWARE IT IS NOT DIRECTLY SUPPORTED OR MAINTAINED BY ALFRESCO LTD.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN      
// THE SOFTWARE.
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

INSTALLATION:
There are 2 ways to install the tools: using the AMP installation method,  or via quick-deploy:
 1) For the AMP installation method, place the support-tools-*.amp file into your Alfresco "amps" folder 
and run the script: "bin/apply-amps.[sh|bat]" with the -force switch.
Alternatively you can execute the following (amending the paths to your case) :
 java -jar ./bin/alfresco-mmt.jar install ./amps/ ./tomcat/webapps/alfresco.war -force
and then clean out the currently deployed web application by removing :
- tomcat/webapps/alfresco/*
- tomcat/work/*
- tomcat/temp/*

2) Quick-Deploy leaves no trace of the amp on the database. This also lets you use these tools to diagnose a current problem in your environment without needing to  rebooting tomcat:

Copy the contents of the "src" folder to your /tomcat/webapps/alfresco so the contents are
merged with your current installation. Once copied, reload webscripts by going to :
http://[host]:[port]/alfresco/service/index
and clicking on "Refresh Web Scripts"
Note: The Tail-Log tool wont cache log entries until the next restart, but the rest of the webscripts will work.


USAGE:
Go to the URL http://[host]:[port]/alfresco/s/enterprise/admin/
New scripts will appear under the Support Tools section.

ACKNOLEDGEMENTS:
Special thanks to:
Mike Farman for his support on this project and parts of the code.
Marco Mancuso for his help on the development.
Jamie Allison for his code review, "polish" and improvements.
Will Abson for his useful advice.
Also to the creators of Smoothie Charts:
http://smoothiecharts.org/ the library from which was quite useful and fun to use


VERSION HISTORY:

1.0 Initial Working version, some UI adjustments needed.
1.1 Code Reviewed and commited to GitHub
1.2 UI improvements by Jamie Allison, added ajax to some webscripts for automation ("Active Sessions")
    Changed the general aspect of the "Scheduled Jobs" section, New tabs abd buttons on "Threaddumps"
    Automated dist generation with Ant.
1.3 Added filesaver.js to fix the "save all" problem with IE8       
