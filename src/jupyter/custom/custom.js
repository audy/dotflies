//
// prevent jupyter notebook from trying to render a huge amount of text
//
// lifted from: https://github.com/ipython/ipython/issues/6516
//
require([
  "notebook/js/outputarea",
  "base/js/dialog",
  "notebook/js/codecell"
], function(oa, dialog, cc) {

  oa.OutputArea.prototype._handle_output = oa.OutputArea.prototype.handle_output
  oa.OutputArea.prototype.handle_output = function (msg) {
    if(!this.count){this.count=0}
    this.count = this.count+String(msg.content.data).length;
    if(this.count > 500) {
      if(!this.drop) {
        console.log('dropping cell output');
      }
      this.drop = true;
      return
    }
    return this._handle_output(msg);
  }

  cc.CodeCell.prototype._execute = cc.CodeCell.prototype.execute;

  // reset counter on execution.
  cc.CodeCell.prototype.execute = function() {
      this.output_area.count = 0;
      this.output_area.drop  = false;
      return this._execute();
  }
});
