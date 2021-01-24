(defmodule {{name}}
  (behaviour gen_statem)
  (export
    ;; gen_statem API implementation
    (start_link 0)
    ;; gen_statem callback implementation
    (init 1)
    (callback_mode 0)
    (format_status 2)
    (handle_event 4)
    (terminate 3)
    (code_change 4)))



; Documentation taken from https://github.com/vim-erlang/vim-erlang-skeletons

;;; ------------------------------------------------------------------
;;; config functions
;;; ------------------------------------------------------------------
;;; ----------------
;;; config functions
;;; ----------------

(defun SERVER () (MODULE))
(defun initial-args () '#())
(defun initial-opts () '())
(defun unknown-event () #(error "Unknown event."))

;;; ------------------------------------------------------------------
;;; gen_statem API implementation
;;; ------------------------------------------------------------------

; see: http://erlang.org/doc/man/gen_statem.html#start_link-3

(defun start_link_local ()
  (start_link_local (initial-args)))

(defun start_link_local(args)
  (start_link_local args (initial-opts)))

(defun start_link_local (args opts)
  (gen_statem:start_link `#(local ,(SERVER)) 
                          (MODULE) 
                          args 
                          opts))

(defun start_link ()
  (start_link (initial-args)))

(defun start_link (args)
  (start_link args (initial-opts)))

(defun start_link (args opts)
  (gen_statem:start_link (MODULE) args opts))

;;; ------------------------------------------------------------------
;;; gen_statem Callback implementation
;;; ------------------------------------------------------------------

;;--------------------------------------------------------------------
;; @private
;; @doc
;; Whenever a gen_statem is started using gen_statem:start/[3,4] or
;; gen_statem:start_link/[3,4], this function is called by the new
;; process to initialize.
;;
;; @spec init(Args) -> {ok, State, Data} |
;;                     {ok, State, Data, Actions} |
;;                     ignore |
;;                     {stop, Reason}
;; @end
;;--------------------------------------------------------------------

; Note: if you need your initial data be different than just
; args, make a function to create initial data from args

(defun init (args)
  (process_flag 'trap_exit 'true)
  `#(ok state-name ,args))

;;--------------------------------------------------------------------
;; @private
;; @doc
;; Define the callback_mode() for this callback module.
;;
;; @spec callback_mode() -> state_functions |
;;                          handle_event_function |
;;                          [state_functions, state_enter] |
;;                          [handle_event_function, state_enter]
;; @end
;;--------------------------------------------------------------------

; Note: this template is for a "handle_event_function" version of gen_statem
; Use the twin template for "state_names" in case you implement
; your own state name functions.

(defun callback_mode ()
  'handle_event_function)

;;--------------------------------------------------------------------
;; @private
;; @doc
;; Called (1) whenever sys:get_status/1,2 is called by gen_statem or
;; (2) when gen_statem terminates abnormally.
;; This callback is optional.
;;
;; @spec format_status(Opt, [PDict, State, Data]) -> Status
;; @end
;;--------------------------------------------------------------------
(defun format_status ((_opts (= (list _process-dict state-name data) data-list))
    (list #('data (list #("State", #(state-name data)))))))

;;--------------------------------------------------------------------
;; @private
;; @doc
;;
;; If callback_mode is handle_event_function, then whenever a
;; gen_statem receives an event from call/2, cast/2, or as a normal
;; process message, this function is called.
;;
;; @spec handle_event(Event, StateName, State) ->
;;                   {next_state, NextState, NewData} |
;;                   {next_state, NextState, NewData, Actions} |
;;                   {keep_state, NewData} |
;;                   {keep_state, NewData, Actions} |
;;                   keep_state_and_data |
;;                   {keep_state_and_data, Actions} |
;;                   {repeat_state, NewData} |
;;                   {repeat_state, NewData, Actions} |
;;                   repeat_state_and_data |
;;                   {repeat_state_and_data, Actions} |
;;                   stop |
;;                   {stop, Reason} |
;;                   {stop, Reason, NewData} |
;;                   {stop_and_reply, Reason, Replies} |
;;                   {stop_and_reply, Reason, Replies, NewData}
;; @end
;;--------------------------------------------------------------------
(defun handle_event 
  ((event event-data state-name _data)
    `(error `#(unhandled-event ,event ,event-data ,state-name)))
  ((`#(call ,_from) event-data state-name _data)
    `(error `#(unhandled-call ,event-data ,state-name))))

;;--------------------------------------------------------------------
;; @private
;; @doc
;; This function is called by a gen_statem when it is about to
;; terminate. It should be the opposite of Module:init/1 and do any
;; necessary cleaning up. When it returns, the gen_statem terminates
;; with Reason. The return value is ignored.
;;
;; @spec terminate(Reason, State, Data) -> Ignored
;; @end
;;--------------------------------------------------------------------
(defun terminate (_reason _state _data)
  'ok)

;;--------------------------------------------------------------------
;; @private
;; @doc
;; Convert process state when code is changed
;;
;; @spec code_change(OldVsn, OldState, OldData, Extra) ->
;;                   {ok, NewState, NewData} |
;;                   Reason
;; @end
;;--------------------------------------------------------------------
(defun code_change (_old-version state data _extra)
  `#(ok ,state ,data))

;;; ------------------------------------------------------------------
;;; Internal state handling functions
;;; ------------------------------------------------------------------