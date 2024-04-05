$PBExportHeader$demo.sra
$PBExportComments$Generated Application Object
forward
global type demo from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type demo from application
string appname = "demo"
string appruntimeversion = "22.2.0.3289"
end type
global demo demo

on demo.create
appname = "demo"
message = create message
sqlca = create transaction
sqlda = create dynamicdescriptionarea
sqlsa = create dynamicstagingarea
error = create error
end on

on demo.destroy
destroy( sqlca )
destroy( sqlda )
destroy( sqlsa )
destroy( error )
destroy( message )
end on

