const mongoose = require('mongoose');
mongoose.set('strictQuery', true);

mongoose.connect('',{
    useNewUrlParser:true,
    useUnifiedTopology:true,    
});