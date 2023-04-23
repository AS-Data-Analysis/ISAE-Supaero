package BasicExercises;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

class ButtonPanel extends JPanel implements ActionListener {
    private int faceValue= 0;
    private JLabel rollLabel;
    private JButton rollButton;
    
    public ButtonPanel() {
    	rollButton = new JButton("Roll");
    	rollLabel = new JLabel("Ready");
    	Font font1 = new Font("Monospaced", Font.PLAIN, 24);
    	rollLabel.setFont(font1);
    	rollButton.setFont(font1);
    	this.add(rollButton);
    	this.add(rollLabel);
    	rollButton.addActionListener(this);
    }
    public void actionPerformed(ActionEvent e) {
    	faceValue = (int)(Math.random()*6+1);
        rollLabel.setText(" "+faceValue);
    }
}