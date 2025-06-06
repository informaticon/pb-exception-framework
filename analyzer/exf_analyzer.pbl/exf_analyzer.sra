forward
global type exf_analyzer from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
u_exf_error_manager gu_e
end variables

global type exf_analyzer from application
string appname = "exf_analyzer"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 22.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = "exf_analyzer.ico"
string appruntimeversion = "25.0.0.3683"
boolean manualsession = false
boolean unsupportedapierror = false
boolean ultrafast = false
boolean bignoreservercertificate = false
uint ignoreservercertificate = 0
long webview2distribution = 0
boolean webview2checkx86 = false
boolean webview2checkx64 = false
string webview2url = "https://developer.microsoft.com/en-us/microsoft-edge/webview2/"
integer highdpimode = 0
end type
global exf_analyzer exf_analyzer

type variables

end variables

on exf_analyzer.create
appname="exf_analyzer"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on exf_analyzer.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;gu_e = create u_exf_error_manager
u_exf_exception_framework_adapter lu_adapter
lu_adapter = create u_exf_exception_framework_adapter
lu_adapter.of_enable_auto_upload(false)
gu_e.of_set_app_adapter(lu_adapter)


lu_adapter.of_enable_auto_upload(true)

open(w_exf_analyzer)
end event


