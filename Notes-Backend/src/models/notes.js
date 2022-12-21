const mongoose = require('mongoose')
const notes = mongoose.model('Note',
{
    note:{
        type:String
    },
    
})

module.exports = notes