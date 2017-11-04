host = db.serverStatus().host;
process = db.serverStatus().process;

if (process == "mongod") {
    isPrimary = db.serverStatus().repl.ismaster;
    isSecondary = db.serverStatus().repl.secondary;
    isArbiter = db.serverStatus().repl.arbiterOnly;

    if (isPrimary) {replRole = "PRIMARY";}
    else if (isSecondary) {replRole = "SECONDARY";}
    else if (isArbiter) {replRole = "ARBITER";}
    else {replRole = "NONE";}
}

prompt = function() {
    if (process == "mongod") {
	return db + "@" + host + ":" + replRole + "> ";
    }
    else {
        return db + "@" + host + "/" + process + "> ";
    }
}
