forward
global type u_tst_service from nonvisualobject
end type
end forward

global type u_tst_service from nonvisualobject
end type
global u_tst_service u_tst_service

forward prototypes
public function string of_globalreplace (string as_source, string as_old, string as_new, boolean ab_ignorecase)
public function string of_globalreplace (string as_source, string as_old, string as_new)
public function long of_explode (string as_string, string as_separator, ref long al_list[])
public function long of_explode (string as_string, string as_separator, ref string as_list[])
public function string of_implode (string as_array[], string as_separator)
public function string of_implode (long al_array[], string as_separator)
public function boolean of_is_inherited_from (ref powerobject apo_object, string as_parent_classname)
public function any of_isnull (any aa_value1, any aa_value2)
public function long of_isnull (long al_value1, long al_value2)
public function string of_isnull (string al_value1, string as_value2)
public function char of_isnull (char ac_value1, char ac_value2)
public function integer of_isnull (integer ai_value1, integer ai_value2)
public function date of_isnull (date ada_value1, date ada_value2)
public function datetime of_isnull (datetime adt_value1, datetime adt_value2)
public function time of_isnull (time at_value1, time at_value2)
public function boolean of_isnull (boolean abo_value1, boolean abo_value2)
public function decimal of_isnull (decimal ade_value1, decimal ade_value2)
public function real of_isnull (real ar_value1, real ar_value2)
public function double of_isnull (double ado_value1, double ado_value2)
public function longlong of_isnull (longlong all_value1, longlong all_value2)
public function unsignedinteger of_isnull (unsignedinteger aui_value1, unsignedinteger aui_value2)
public function unsignedlong of_isnull (unsignedlong aul_value1, unsignedlong aul_value2)
public function long of_isnull_l (long al_value)
public function string of_isnull_s (string as_value)
public function boolean of_is_value_in_array (readonly any aa_value, any aa_array[])
public function any of_isnull (any aa_values[])
public function boolean of_is_type_compatible (any aa_value_left, any aa_value_right)
public function boolean of_is_powerobject (powerobject apo_value)
public function boolean of_is_powerobject (any aa_value)
public function long of_pos (string as_string, string as_search[], long al_start, ref long al_found)
public function long of_run (string as_command, ref string as_stdout)
public function long of_run (string as_command)
end prototypes

public function string of_globalreplace (string as_source, string as_old, string as_new, boolean ab_ignorecase);long ll_len_old, ll_len_new, ll_pos

ll_len_old = len(as_old)
ll_len_new = len(as_new)
ll_pos = 1

if ab_ignorecase then
	ll_pos = pos(lower(as_source), lower(as_old), ll_pos)
	do while ll_pos > 0
		 as_source = replace(as_source, ll_pos, ll_len_old, as_new)
		ll_pos = pos(lower(as_source), lower(as_old), ll_pos + ll_len_new)
	loop
else
	ll_pos = pos(as_source, as_old, ll_pos)
	do while ll_pos > 0
		 as_source = replace(as_source, ll_pos, ll_len_old, as_new)
		ll_pos = pos(as_source, as_old, ll_pos + ll_len_new)
	loop
end if

return as_source

end function

public function string of_globalreplace (string as_source, string as_old, string as_new);//The default is to ignore Case
return of_globalreplace(as_source, as_old, as_new, true)

end function

public function long of_explode (string as_string, string as_separator, ref long al_list[]);//Zweck		Nimmt as_string auseinander und füllt ihn in den Array al_list ab
//Hinweis	Ein Separator am Schluss des Strings wird ignoriert. 
//				Es wird nicht wie z.Bsp. bei einem CSV noch ein zusätzlicher leerer Array-Eintrag hinzugefügt.
//				Dies wird so belassen, damit bestehender Code nicht plötzlich anders reagiert.

long ll_pos1 = 1, ll_pos2, ll_count = 1, ll_leer[]
string ls_piece

al_list = ll_leer	//Init mit einem leeren Array

do while ll_pos2 < len(as_string)
	ll_pos2 = pos(as_string, as_separator, ll_pos1)
	//2018-07-09 Martin Abplanalp, Ticket 15713: Leere Elemente wurden nicht korrekt verarbeitet
	//if ll_pos2 <= ll_pos1 then
	//	ll_pos2 = len(as_string) + 1
	//end if
	if ll_pos2 = 0 then ll_pos2 = len(as_string) + 1
	
	ls_piece = mid(as_string, ll_pos1, ll_pos2 - ll_pos1)
	al_list[ll_count] = long(ls_piece)
	ll_count++
	ll_pos1 = ll_pos2 + len(as_separator)	
loop

return upperbound(al_list)
end function

public function long of_explode (string as_string, string as_separator, ref string as_list[]);//Zweck		Nimmt as_string auseinander und füllt ihn in den Array as_list ab
//Hinweis	Ein Separator am Schluss des Strings wird ignoriert. 
//				Es wird nicht wie z.Bsp. bei einem CSV noch ein zusätzlicher leerer Array-Eintrag hinzugefügt.
//				Dies wird so belassen, damit bestehender Code nicht plötzlich anders reagiert.

long ll_pos1 = 1, ll_pos2, ll_count = 1
string ls_piece, ls_leer[]

as_list = ls_leer	//Init mit einem leeren Array

do while ll_pos2 < len(as_string)
	ll_pos2 = pos(as_string, as_separator, ll_pos1)
	//2018-07-09 Martin Abplanalp, Ticket 15713: Leere Elemente wurden nicht korrekt verarbeitet
	//if ll_pos2 <= ll_pos1 then
	//	ll_pos2 = len(as_string) + 1
	//end if
	if ll_pos2 = 0 then ll_pos2 = len(as_string) + 1
	
	ls_piece = mid(as_string, ll_pos1, ll_pos2 - ll_pos1)
	as_list[ll_count] = ls_piece
	ll_count++
	ll_pos1 = ll_pos2 + len(as_separator)	
loop

return upperbound(as_list)
end function

public function string of_implode (string as_array[], string as_separator);//Zweck		Setzt Inhalt von as_array zu einem String zusammen

long ll_i
string ls_string

for ll_i = 1 to upperbound(as_array)
	if ll_i > 1 then ls_string += as_separator
	//2019-06-25 Martin Abplanalp, Ticket 15839: NULL-Wert abfangen
	ls_string += this.of_isnull_s(as_array[ll_i])
next

return ls_string

end function

public function string of_implode (long al_array[], string as_separator);//Zweck		Setzt Inhalt von al_array zu einem String zusammen

long ll_i
string ls_string

for ll_i = 1 to upperbound(al_array)
	if ll_i > 1 then ls_string += as_separator
	//2019-06-25 Martin Abplanalp, Ticket 15839: NULL-Wert abfangen
	ls_string += this.of_isnull_s(string(al_array[ll_i]))
next

return ls_string

end function

public function boolean of_is_inherited_from (ref powerobject apo_object, string as_parent_classname);//Zweck		Prüft ein Objekt ob es von einem bestimmten Parentobjekt vererbt wurde
//				Das Objekt muss nicht direkt vom Parentobjekt vererbt sein, es können auch eine Anzahl Vererbungstufen dazwischen liegen
//				Beispiele: 
//				Objekt = dis2_w_dis_start, Parent-Objekt = dis1_w_dis_start -> Return = true
//				Objekt = dis2_w_dis_start, Parent-Objekt = w_master -> Return = true
//Arg			ref apo_object	Zu prüfendes Object
//				as_parent_classname
//Return		true	apo_object ist ein Nachkomme von as_parent_classname
//				false	apo_object ist kein Nachkomme von as_parent_classname
//Erstellt	2017-11-28 Martin Abplanalp

classdefinition lcd_temp

lcd_temp = apo_object.classdefinition
as_parent_classname = lower(as_parent_classname)

do while isvalid(lcd_temp)
	if lower(lcd_temp.name) = as_parent_classname then return true
	lcd_temp = lcd_temp.ancestor
loop

return false

end function

public function any of_isnull (any aa_value1, any aa_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Arg			aa_value1
//				aa_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2019-06-24 Martin Abplanalp	Ticket 16012
//Geändert	2021-11-24 Simon Reichenbach	Ticket 17531

return of_isnull({aa_value1, aa_value2})
end function

public function long of_isnull (long al_value1, long al_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	al_value1
//				al_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(al_value1) then
	return al_value2
else
	return al_value1
end if
end function

public function string of_isnull (string al_value1, string as_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	al_value1
//				as_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(al_value1) then
	return as_value2
else
	return al_value1
end if
end function

public function char of_isnull (char ac_value1, char ac_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	ac_value1
//				ac_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(ac_value1) then
	return ac_value2
else
	return ac_value1
end if
end function

public function integer of_isnull (integer ai_value1, integer ai_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	ai_value1
//				ai_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(ai_value1) then
	return ai_value2
else
	return ai_value1
end if
end function

public function date of_isnull (date ada_value1, date ada_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	ada_value1
//				ada_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(ada_value1) then
	return ada_value2
else
	return ada_value1
end if
end function

public function datetime of_isnull (datetime adt_value1, datetime adt_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	adt_value1
//				adt_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(adt_value1) then
	return adt_value2
else
	return adt_value1
end if
end function

public function time of_isnull (time at_value1, time at_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	at_value1
//				at_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(at_value1) then
	return at_value2
else
	return at_value1
end if
end function

public function boolean of_isnull (boolean abo_value1, boolean abo_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	abo_value1
//				abo_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(abo_value1) then
	return abo_value2
else
	return abo_value1
end if
end function

public function decimal of_isnull (decimal ade_value1, decimal ade_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	ade_value1
//				ade_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(ade_value1) then
	return ade_value2
else
	return ade_value1
end if
end function

public function real of_isnull (real ar_value1, real ar_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	ar_value1
//				ar_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(ar_value1) then
	return ar_value2
else
	return ar_value1
end if
end function

public function double of_isnull (double ado_value1, double ado_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	ado_value1
//				ado_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(ado_value1) then
	return ado_value2
else
	return ado_value1
end if
end function

public function longlong of_isnull (longlong all_value1, longlong all_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	all_value1
//				all_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(all_value1) then
	return all_value2
else
	return all_value1
end if
end function

public function unsignedinteger of_isnull (unsignedinteger aui_value1, unsignedinteger aui_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	aui_value1
//				aui_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(aui_value1) then
	return aui_value2
else
	return aui_value1
end if
end function

public function unsignedlong of_isnull (unsignedlong aul_value1, unsignedlong aul_value2);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	aul_value1
//				aul_value2
//Return		Der erste Wert der NOT NULL ist.
//				Falls beide Werte NULL sind, wird NULL zurückgegeben.
//Erstellt	2021-11-30 Simon Reichenbach	Ticket 17531

if isnull(aul_value1) then
	return aul_value2
else
	return aul_value1
end if
end function

public function long of_isnull_l (long al_value);//Zweck		Ersetzt NULL-Wert durch 0
//Arg			aa_value
//Return		0 wenn al_value = NULL, sonst al_value
//Erstellt	2019-06-24 Martin Abplanalp, Ticket 16012

if isnull(al_value) then 
	return 0
else
	return al_value
end if

end function

public function string of_isnull_s (string as_value);//Zweck		Ersetzt NULL-Wert durch Leerstring
//Arg			as_value
//Return		Leerstring wenn as_value = NULL, sonst as_value
//Erstellt	2019-06-24 Martin Abplanalp, Ticket 16012

if isnull(as_value) then 
	return ''
else
	return as_value
end if

end function

public function boolean of_is_value_in_array (readonly any aa_value, any aa_array[]);//Zweck		Prüft, ob eine Variable in einem Array vorhanden ist
//Argument	aa_value		Wert, welcher gesucht wird
//				aa_array[]	Array, in welchem der Wert gesucht wird
//Retrun		true	aa_value ist in aa_array vorhanden
//				false	aa_value ist in aa_array NICHT vorhanden
//Erstellt	2021-11-18 Simon Reichenbach	Ticket 15951

long		ll_i
string	ls_data_type

ls_data_type = classname(aa_value)

for ll_i = lowerbound(aa_array) to upperbound(aa_array)
	if classname(aa_array[ll_i]) = ls_data_type then
		if aa_array[ll_i] = aa_value then
			return true
		end if
	elseif isnull(aa_array[ll_i]) and isnull(ls_data_type) then
		//2023-03-31 Simon Reichenbach, Ticket 310542: NULL Werte in Array mit NULL finden
		return true
	end if
next

return false
end function

public function any of_isnull (any aa_values[]);//Zweck		Ersetzt NULL-Wert
//				Analog der DB-Funktion isnull
//Argument	aa_values[]	Array von Kanditaten, muss mindestens die Länge 1 aufweisen
//Return		Das erste Element, welches nicht NULL ist wird zurückgegeben
//				Falls alle Werte NULL sind, wird das letzte Element zurückgegeben (NULL)
//Erstellt	2019-06-24 Martin Abplanalp	Ticket 16012
//Geändert	2021-11-24 Simon Reichenbach	Ticket 17531

long ll_i
long ll_ret = 0

choose case upperbound(aa_values)
	case 0
		throw(gu_e.iu_as.of_re_illegalargument(gu_e.of_new_error() &
			.of_push(populateerror(0, 'aa_values muss mindestens ein Element beinhalten')) &
		))
		
	case 1
		return aa_values[1]
		
end choose

for ll_i = 2 to upperbound(aa_values)
	if not of_is_type_compatible(aa_values[ll_i - 1], aa_values[ll_i]) then
		throw(gu_e.iu_as.of_re_illegalargument(gu_e.of_new_error() &
			.of_push(populateerror(0, 'Die übergebenen Argumente sind zueinander nicht Typ-kompatibel')) &
			.of_push('aa_values[ll_i - 1]', aa_values[ll_i - 1]) &
			.of_push('aa_values[ll_i]', aa_values[ll_i]) &
			.of_push('aa_values', aa_values) &
		))
	end if
	if ll_ret = 0 and not isnull(aa_values[ll_i - 1]) then
		ll_ret = ll_i - 1
	end if
next

if ll_ret = 0 then ll_ret = upperbound(aa_values)
return aa_values[ll_ret]
end function

public function boolean of_is_type_compatible (any aa_value_left, any aa_value_right);//Zweck		Überprüft, ob eine Variable einier anderen Variable zugewiesen werden könnte
//				Funktioniert im Gegensatz zu of_is_inherited_from() auch für triviale Datentypen
//Argument	aa_value_left	
//				aa_value_right	
//Return		true	aa_value_left = aa_value_right ist möglich
//				null	Die Prüfung kann nicht durchgeführt werden, weil eines der Argumente NULL oder unbekannt ist
//				false	sonst
//Erstellt	2021-11-24 Simon Reichenbach	Ticket 17531

powerobject lpo_temp
boolean lbo_left_is_po
boolean lbo_right_is_po
boolean lbo_null
setnull(lbo_null)

lbo_left_is_po = of_is_powerobject(aa_value_left)
lbo_right_is_po = of_is_powerobject(aa_value_right)

//Entweder sind links und rechts ein PowerObject, oder nicht
//z.B. links ein PowerObject und rechts ein long sind inkompatibel
if lbo_left_is_po <> lbo_right_is_po then
	return false
end if

//Wenn links und rechts ein PowerObject sind, muss die Basis-Klasse des rechten Objekts der linken Klasse entsprechen
if lbo_left_is_po and lbo_right_is_po then
	if not isvalid(aa_value_left) or not isvalid(aa_value_right) then
		//of_is_inherited_from() funktioniert nur bei instanziierten Objekten
		return lbo_null
	end if
	lpo_temp = aa_value_right
	return of_is_inherited_from(lpo_temp, classname(aa_value_left))
end if

//Vergleich trivialer Datentypen
if isnull(aa_value_right) or isnull(aa_value_left) then
	return lbo_null
end if

choose case classname(aa_value_left)
	case 'long', 'integer', 'unsignedinteger', 'unsignedlong', 'byte', 'longlong', 'decimal', 'real', 'double'
		return of_is_value_in_array(classname(aa_value_right), {'long', 'integer', 'unsignedinteger', 'unsignedlong', 'byte', 'longlong', 'decimal', 'real', 'double'})
	
	case 'string', 'char'
		return of_is_value_in_array(classname(aa_value_right), {'string', 'char'})
		
	case 'boolean'
		return classname(aa_value_right) = 'boolean'
	
	case 'date'
		return classname(aa_value_right) = 'date'
	
	case 'time'
		return classname(aa_value_right) = 'time'
	
	case 'datetime'
		return classname(aa_value_right) = 'datetime'
	
	case else
		return lbo_null
		
end choose
end function

public function boolean of_is_powerobject (powerobject apo_value);//Zweck		Prüft, ob ein bestimmte Variable ein Objekt beinhaltet
//Argument	aa_value	
//Return		true	aa_value beinhaltet ein Powerobject
//				false	sonst
//Erstellt	2021-11-24 Simon Reichenbach

return true

end function

public function boolean of_is_powerobject (any aa_value);return false
end function

public function long of_pos (string as_string, string as_search[], long al_start, ref long al_found);//Zweck		Sucht das erste Vorkommen der zu suchenden Strings
//Argument	as_string		Zu durchsuchenden String
//				as_search[]		Zu suchende Strings
//				al_start			Startposition der Suche
//				ref al_found	Welcher Eintrag in as_search[] als erster gefunden wurde
//Return		Gefundene Position
//Erstellt	2022-05-23 Martin Abplanalp, Ticket 300035

long ll_i, ll_pos_temp, ll_pos

al_found = 0
for ll_i = 1 to upperbound(as_search[])
	ll_pos_temp = pos(as_string, as_search[ll_i], al_start)
	if ll_pos_temp > 0 and (ll_pos_temp < ll_pos or ll_pos = 0) then
		ll_pos = ll_pos_temp
		al_found = ll_i
	end if
next

return ll_pos

end function

public function long of_run (string as_command, ref string as_stdout);long ll_ret

oleobject lole_wsh
oleobject lole_exec

lole_wsh = create oleobject
lole_wsh.connecttonewobject('wscript.shell')
lole_exec = lole_wsh.exec(as_command)

ll_ret = lole_exec.exitcode
as_stdout = lole_exec.stdout.readall()

lole_exec.disconnectobject()
lole_wsh.disconnectobject()

return ll_ret
end function

public function long of_run (string as_command);long ll_ret

oleobject lole_wsh
oleobject lole_exec

lole_wsh = create oleobject
lole_wsh.connecttonewobject('wscript.shell')
lole_exec = lole_wsh.exec(as_command)

ll_ret = lole_exec.exitcode

lole_exec.disconnectobject()
lole_wsh.disconnectobject()

return ll_ret
end function

on u_tst_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_tst_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
end event

