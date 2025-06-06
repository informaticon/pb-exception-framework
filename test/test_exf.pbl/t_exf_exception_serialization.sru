forward
global type t_exf_exception_serialization from u_tst_testcase
end type
type datastore_1 from datastore within t_exf_exception_serialization
end type
end forward

global type t_exf_exception_serialization from u_tst_testcase
event te_blob ( ) throws throwable
event te_error_data ( ) throws throwable
event te_upload_download ( ) throws u_exf_ex
event te_base64 ( ) throws u_exf_ex
event te_parse_blob ( ) throws u_exf_ex
datastore_1 datastore_1
end type
global t_exf_exception_serialization t_exf_exception_serialization

type variables
protected u_exf_serialization pu_serialization
end variables

forward prototypes
public function u_tst_stringarray of_setup (u_tst_context au_tst_context)
public function string of_get_filepath (string as_filename)
end prototypes

event te_blob();//Zweck		Tested die Serialisierung von u_exf_blob
//Erstellt	2022-08-17 Simon Reichenbach

u_exf_blob lu_wanted
u_exf_blob lu_found

lu_wanted = create u_exf_blob
lu_wanted.is_name = '$äpü__12~t~'"'
lu_wanted.ibl_data = blob('blob$äpü__12~t~'"', encodingansi!)
lu_wanted.is_type = 'string$äpü__12~t~'"'
lu_wanted.ibo_confidential = false

lu_found = pu_serialization.of_deserialize_blob(pu_serialization.of_serialize(lu_wanted))

pu_context.of_assert_equal(lu_found, lu_wanted, 'Blob changed after serialization and deserialization')


end event

event te_error_data();//Zweck		Tested die Serialisierung von u_exf_error_data
//Erstellt	2022-08-17 Simon Reichenbach

u_exf_error_data lu_wanted
u_exf_error_data lu_found
u_exf_blob lu_blob
long ll_handle
string ls_error
jsonparser ljp_parser
ljp_parser = create jsonparser

lu_blob = create u_exf_blob
lu_blob.is_type = 'Type $äpü__12~t~'"'
lu_blob.is_name = 'Name $äpü__12~t~'"'
lu_blob.ibl_data = blob('Data $äpü__12~t~'"')

lu_wanted = create u_exf_error_data
lu_wanted.of_set_message(42, 'Message $äpü__12~t~'"')
lu_wanted.of_set_type('u_exf_ex')
lu_wanted.of_push('Hallo', 'Welt')
lu_wanted.of_push('Halbwahrheit', 21)
lu_wanted.of_push('meinblob', lu_blob)
lu_wanted.of_push('zweiblob', lu_blob)

lu_found = pu_serialization.of_deserialize_error_data(pu_serialization.of_serialize(lu_wanted))

pu_context.of_assert_equal(lu_found, lu_wanted, 'Error-Data changed after serialization and deserialization')


end event

event te_upload_download();
string ls_name
string ls_key
u_exf_error_data lu_ex 
u_exf_blob lu_blob
datastore lds_data

if not gu_e.of_get_app_adapter().of_is_auto_ubload_enabled() then
	pu_context.event ue_log('auto upload is disabled - skipping test')
	return
end if
lu_blob = create u_exf_blob
lu_blob.is_type = 'Type $äpü__12~t~'"'
lu_blob.is_name = 'Name $äpü__12~t~'"'
lu_blob.ibl_data = blob('Data $äpü__12~t~'"')

lds_data = create datastore
lds_data.dataobject = 'd_temp'
lds_data.setitem(1, 'fg', 'Hallo Welt')

lu_ex = gu_e.iu_as.of_ex(gu_e.of_new_error() &
	.of_push(populateerror(42, 'Message $äpü__12~t~'"')) &
	.of_push('Hallo', 'Welt') &
	.of_push('Halbwahrheit', 21) &
	.of_push('meinblob', lds_data) &
	.of_push('zweiblob', lu_blob) &
).of_get_error()
ls_name = string(datetime(today(), now()), 'yyyymmdd_hhmmss_ffffff') + '_' + string(rand(32767))
ls_key = gu_e.of_get_app_adapter().of_upload(lu_ex, ls_name)
pu_context.event ue_log('name: ' + ls_name + '; key: ' + ls_key)
end event

event te_base64();string ls2
string ls1
blob lbl1
blob lbl2
u_exf_serialization lu_serialization
coderobject lco_code
lco_code = create coderobject
lu_serialization = create u_exf_serialization

ls1 = 'ABCDäöü12_&%ç'
lbl1 = blob(ls1, encodingutf8!)
ls2 = lu_serialization.of_base64encode(lbl1, '')
pu_context.of_assert_equal(ls2, lco_code.base64encode(lbl1), 'encoding does not work properly')
lbl2 = lu_serialization.of_base64decode(ls2)
pu_context.of_assert_equal(string(lbl2, encodingutf8!), ls1, 'decoding does not work properly')

end event

event te_parse_blob();u_exf_blob lu_else
u_exf_blob lu_blob
lu_else = create u_exf_blob
lu_else.ibl_data = blob('ELSE', encodingutf8!)

lu_blob = gu_e.of_get_app_adapter().of_parse_to_blob(1, lu_else)
pu_context.of_assert_equal(string(lu_blob.ibl_data, encodingutf8!), '1', 'Primitive type test failed')

lu_blob = gu_e.of_get_app_adapter().of_parse_to_blob(this, lu_else)
pu_context.of_assert_equal(string(lu_blob.ibl_data, encodingutf8!), 'ELSE', 'Object **without** of_to_string() function test failed')

lu_blob = gu_e.of_get_app_adapter().of_parse_to_blob(lu_else, lu_else)
pu_context.of_assert_equal(string(lu_blob.ibl_data, encodingutf8!), lu_else.of_to_string(), &
	'Object **with** of_to_string() function test failed' &
)

end event

public function u_tst_stringarray of_setup (u_tst_context au_tst_context);
pu_serialization = create u_exf_serialization
return super::of_setup(au_tst_context)
end function

public function string of_get_filepath (string as_filename);return left(getcurrentdirectory(), lastpos(getcurrentdirectory(), '\') - 1)  + '\test\testdata\' + as_filename
end function

on t_exf_exception_serialization.create
call super::create
this.datastore_1=create datastore_1
end on

on t_exf_exception_serialization.destroy
call super::destroy
destroy(this.datastore_1)
end on

type datastore_1 from datastore within t_exf_exception_serialization descriptor "pb_nvo" = "true" 
string dataobject = "d_temp"
end type

on datastore_1.create
call super::create
TriggerEvent( this, "constructor" )
end on

on datastore_1.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on


