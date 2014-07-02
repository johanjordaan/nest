mongoose = require 'mongoose'


TodoSchema = mongoose.Schema 
   entry_date : Date
   text : String
   done : Boolean

if module?
  module.exports = TodoSchema