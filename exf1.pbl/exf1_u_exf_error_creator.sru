forward
global type exf1_u_exf_error_creator from nonvisualobject
end type
end forward

global type exf1_u_exf_error_creator from nonvisualobject
event ue_register_error ( u_exf_error_data au_error )
end type
global exf1_u_exf_error_creator exf1_u_exf_error_creator

forward prototypes
public function u_exf_ex of_ex (u_exf_error_data au_error)
public function u_exf_ex_io of_ex_io (u_exf_error_data au_error)
public function u_exf_re of_re (u_exf_error_data au_error)
public function u_exf_re_notimplemented of_re_notimplemented (u_exf_error_data au_error)
public function u_exf_re_io of_re_io (u_exf_error_data au_error)
public function u_exf_re_database of_re_database (u_exf_error_data au_error)
public function u_exf_re_invalidstate of_re_invalidstate (u_exf_error_data au_error)
public function u_exf_re_systemerror of_re_systemerror (u_exf_error_data au_error)
public function u_exf_re_illegalargument of_re_illegalargument (u_exf_error_data au_error)
public function u_exf_re of_re (u_exf_error_data au_error, string as_classname)
public function u_exf_ex of_ex (u_exf_error_data au_error, string as_classname)
public function u_exf_ex_webrequest of_ex_webrequest (u_exf_error_data au_error)
end prototypes

event ue_register_error(u_exf_error_data au_error);//Zweck		Dummy-Event, wird immer dann aufgerufen,
//				wenn ein Error-Objekt in eine Exception/RuntimeError verpackt wird
//				Der Event kann (und wird) in u_exf_error_manager überschrieben werden
//Argument	au_error	
//Erstellt	2020-11-17 Simon Reichenbach
end event

public function u_exf_ex of_ex (u_exf_error_data au_error);//Zweck		Erstellt ein u_exf_ex-Objekt
//				u_exf_ex ist die allgemeinste checked exception
//				Wenn möglich sollte man ein eigener Exception-Typ verwenden
//Argument	au_error	
//Return		u_exf_ex	
//Erstellt	2021-02-22 Simon Reichenbach

u_exf_ex lu_e
lu_e = create u_exf_ex

lu_e.of_set_error(au_error)
this.event ue_register_error(au_error)

return lu_e
end function

public function u_exf_ex_io of_ex_io (u_exf_error_data au_error);//Zweck		Erstellt ein u_exf_ex_io-Objekt
//				u_exf_ex_io beschreibt einen erwartbaren Fehler bei der Ein- und Ausgabe
//				(z.B. wenn fileopen() fehlschlägt)
//Argument	au_error	
//Return		u_exf_ex_io
//Erstellt	2021-02-22 Simon Reichenbach

u_exf_ex_io lu_e
lu_e = create u_exf_ex_io

lu_e.of_set_error(au_error)
this.event ue_register_error(au_error)

return lu_e
end function

public function u_exf_re of_re (u_exf_error_data au_error);//Zweck		Erstellt ein u_exf_re-Objekt
//				u_exf_re ist die allgemeinste unchecked exception (=RuntimeError)
//				Wenn möglich sollte man einen spezialisierten Exception-Typ verwenden
//Argument	au_error	
//Return		u_exf_re
//Erstellt	2021-02-22 Simon Reichenbach

u_exf_re lu_e
lu_e = create u_exf_re

lu_e.of_set_error(au_error)
this.event ue_register_error(au_error)

return lu_e
end function

public function u_exf_re_notimplemented of_re_notimplemented (u_exf_error_data au_error);//Zweck		Erstellt ein u_exf_re_notimplemented-Objekt
//				u_exf_re_notimplemented wird für die Implementierung von abstrakten Klassen benötigt
//				(man will z.B. den Entwickler zwingen, eine bestimmte Funktion zu überschreiben und 
//				wirft deshalb in der Basisklasse eine solche unchecked exception)
//Argument	au_error	
//Return		u_exf_re_notimplemented
//Erstellt	2021-02-22 Simon Reichenbach

u_exf_re_notimplemented lu_e
lu_e = create u_exf_re_notimplemented

lu_e.of_set_error(au_error)
this.event ue_register_error(au_error)

return lu_e
end function

public function u_exf_re_io of_re_io (u_exf_error_data au_error);//Zweck		Erstellt ein u_exf_re_io-Objekt
//				u_exf_re_io beschreibt einen unerwarteten Fehler bei der Ein- und Ausgabe 
//				(z.B. wenn fileclose() fehlschlägt).
//Argument	au_error	
//Return		u_exf_re_io
//Erstellt	2021-02-22 Simon Reichenbach

u_exf_re_io lu_e
lu_e = create u_exf_re_io

lu_e.of_set_error(au_error)
this.event ue_register_error(au_error)

return lu_e
end function

public function u_exf_re_database of_re_database (u_exf_error_data au_error);//Zweck		Erstellt ein u_exf_re_database-Objekt
//				u_exf_re_database beschreibt einen Datenbankfehler oder einen Fehler 
//				in einem Datawindow oder Datastore
//				Obwohl ein Datenbankfehler oft eine checked exception sein sollte, 
//				wird im A3 aus Kompatibilitätsgründen dafür immer eine unchecked exception geworfen
//				u_exf_re_database sollte in der Regel nur vom Framework (inf1) geworfen werden
//Argument	au_error	
//Return		u_exf_re_database
//Erstellt	2021-02-22 Simon Reichenbach

u_exf_re_database lu_e
lu_e = create u_exf_re_database

lu_e.of_set_error(au_error)
this.event ue_register_error(au_error)

return lu_e
end function

public function u_exf_re_invalidstate of_re_invalidstate (u_exf_error_data au_error);//Zweck		Erstellt ein u_exf_re_invalidstate-Objekt
//				u_exf_re_invalidstate kann geworfen werden, wenn ein Objekt in einen ungültigen 
//				(inkonsistenten) Zustand geraten ist
//				Dies wäre z.B. der Fall, wenn in zwei Instanzvariablen je ein Array gespeichert würde,
//				welche gleich lang sein müssten und dann z.B. ein 3.Schicht-Entwickler eines der 
//				Arrays direkt modifizieren würde, so dass die beiden Arrays nicht mehr gleich lang sind
//Argument	au_error	
//Return		u_exf_re_invalidstate
//Erstellt	2021-02-22 Simon Reichenbach

u_exf_re_invalidstate lu_e
lu_e = create u_exf_re_invalidstate

lu_e.of_set_error(au_error)
this.event ue_register_error(au_error)

return lu_e
end function

public function u_exf_re_systemerror of_re_systemerror (u_exf_error_data au_error);//Zweck		Erstellt ein u_exf_re_systemerror-Objekt
//				u_exf_re_systemerror wird im systemerror-Event des A3 geworfen
//				und darf nicht anderweitig verwendet werden
//Argument	au_error	
//Return		u_exf_re_systemerror
//Erstellt	2021-02-22 Simon Reichenbach

u_exf_re_systemerror lu_e
lu_e = create u_exf_re_systemerror

lu_e.of_set_error(au_error)
this.event ue_register_error(au_error)

return lu_e
end function

public function u_exf_re_illegalargument of_re_illegalargument (u_exf_error_data au_error);//Zweck		Erstellt ein u_exf_re_illegalargument-Objekt
//				u_exf_re_illegalargument kann geworfen werden, wenn die einer Funktion übergebenen
//				Argumente nicht den Anforderungen entsprechen 
//				(z.B. wenn ein Argument unerlaubt NULL ist, oder ein long nicht <= 0 sein darf)
//Argument	au_error	
//Return		u_exf_re_illegalargument
//Erstellt	2021-02-22 Simon Reichenbach

u_exf_re_illegalargument lu_e
lu_e = create u_exf_re_illegalargument

lu_e.of_set_error(au_error)
this.event ue_register_error(au_error)

return lu_e
end function

public function u_exf_re of_re (u_exf_error_data au_error, string as_classname);//Zweck		Erstellt ein von u_exf_re erbendes Objekt
//				Wird benötigt, um dynamisch Exceptions werfen zu können
//Argument	au_error			Fehler
//				as_classname	Zu verwendende Klasse
//Return		u_exf_re			Instanz vom Typ as_classname
//Erstellt	2021-02-11 Simon Reichenbach

u_exf_re lu_e

lu_e = create using as_classname

lu_e.of_set_error(au_error)
this.event ue_register_error(au_error)

return lu_e

end function

public function u_exf_ex of_ex (u_exf_error_data au_error, string as_classname);//Zweck		Erstellt ein von u_exf_ex erbendes Objekt
//				Wird benötigt, um dynamisch Exceptions werfen zu können
//Argument	au_error			Fehler
//				as_classname	Zu verwendende Klasse
//Return		u_exf_ex			Instanz vom Typ as_classname
//Erstellt	2021-02-11 Simon Reichenbach

u_exf_ex lu_e

lu_e = create using as_classname

lu_e.of_set_error(au_error)
this.event ue_register_error(au_error)

return lu_e

end function

public function u_exf_ex_webrequest of_ex_webrequest (u_exf_error_data au_error);//Zweck		Erstellt ein u_exf_ex_webrequest-Objekt
//				u_exf_ex_webrequest beschreibt einen erwartbaren Fehler bei einem Webrequest
//Argument	au_error	
//Return		u_exf_ex_webrequest
//Erstellt	2022-06-07 Martin Abplanalp, Ticket 300227

u_exf_ex_webrequest lu_e
lu_e = create u_exf_ex_webrequest

lu_e.of_set_error(au_error)
this.event ue_register_error(au_error)

return lu_e
end function

on exf1_u_exf_error_creator.create
call super::create
TriggerEvent( this, "constructor" )
end on

on exf1_u_exf_error_creator.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

