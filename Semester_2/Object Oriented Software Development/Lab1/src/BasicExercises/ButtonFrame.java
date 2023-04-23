package BasicExercises;

import java.awt.*;
import javax.swing.*;

public class ButtonFrame extends JFrame {
	public ButtonFrame() {
		super ("Game of Chance");
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setSize(220, 70);
		Container contentPane= this.getContentPane();
		ButtonPanel bp = new ButtonPanel();
        contentPane.add(bp, BorderLayout.CENTER); 
	}
}