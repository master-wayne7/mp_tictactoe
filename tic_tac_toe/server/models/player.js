const mongoose = require('mongoose');

const playerSchema = new mongoose.Schema({
    nickname:{
        type: String,
        trim:true,
    },
    socketID:{
        type:String,
        default: 0,
    },
    points:{
        type:Number,
        default:0,
    },
    playerType:{
        require:true,
        type:String,
    }
});

module.exports = playerSchema;