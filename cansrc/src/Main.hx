package;

import feathers.controls.Application;
import feathers.style.Theme;
import ir.grantech.canvas.themes.CanTheme;

class Main extends Application {
	public function new() {
		Theme.setTheme(new CanTheme());
		super();
	}
}