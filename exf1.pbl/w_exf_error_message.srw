forward
global type w_exf_error_message from exf1_w_exf_error_message
end type
end forward

global type w_exf_error_message from exf1_w_exf_error_message
end type
global w_exf_error_message w_exf_error_message

on w_exf_error_message.create
call super::create
end on

on w_exf_error_message.destroy
call super::destroy
end on

type st_error from exf1_w_exf_error_message`st_error within w_exf_error_message
end type

type cb_send from exf1_w_exf_error_message`cb_send within w_exf_error_message
end type

type cb_copy from exf1_w_exf_error_message`cb_copy within w_exf_error_message
end type

type cb_save from exf1_w_exf_error_message`cb_save within w_exf_error_message
end type

type cb_ok from exf1_w_exf_error_message`cb_ok within w_exf_error_message
end type

type cb_more from exf1_w_exf_error_message`cb_more within w_exf_error_message
end type

type st_title from exf1_w_exf_error_message`st_title within w_exf_error_message
end type

type tv_data from exf1_w_exf_error_message`tv_data within w_exf_error_message
end type

type ip_icon from exf1_w_exf_error_message`ip_icon within w_exf_error_message
end type

type r_gray from exf1_w_exf_error_message`r_gray within w_exf_error_message
end type

type mle_data from exf1_w_exf_error_message`mle_data within w_exf_error_message
end type

type st_box from exf1_w_exf_error_message`st_box within w_exf_error_message
end type

type dw_exf_data from exf1_w_exf_error_message`dw_exf_data within w_exf_error_message
end type

