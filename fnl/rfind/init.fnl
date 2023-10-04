; Copyright 2023 Lajos Koszti

; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the “Software”), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:

; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.

; THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

(local math (require :math))

(fn is_visual_mode_p []
  (let [mode (vim.fn.mode)]
    (or (= mode "v") (= mode "V") (= mode "\\<C-v>"))
    ))

(fn get_visual_start_line_num []
  (if (is_visual_mode_p)
    (vim.fn.line ".")
    (vim.fn.line "'<"))
  )

(fn get_visual_end_line_num []
  (if (is_visual_mode_p)
    (vim.fn.line "v")
    (vim.fn.line "'>"))
  )

(fn get_find_command [start_pos end_pos]
  (string.format "/\\%%>%dl\\%%<%dl" (- start_pos 1) (+ end_pos 1))
  )

(fn get_feedkeys [start_pos end_pos]
  (string.format
    "%s%s"
    (vim.api.nvim_replace_termcodes "<esc>" true false true)
    (get_find_command start_pos end_pos))
  )

(fn find_in_range [start_pos end_pos]
  (vim.api.nvim_feedkeys
    (get_feedkeys start_pos end_pos)
    "ni"
    false)
  )

(fn find_in_visual []
  (let [
        start_pos (get_visual_start_line_num)
        end_pos (get_visual_end_line_num)
        ]
    (find_in_range (math.min start_pos end_pos) (math.max start_pos end_pos))
    ))

{
 :visual find_in_visual
 :range find_in_range
 }
