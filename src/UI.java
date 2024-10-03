import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;
import java.util.List;

public class UI {

    private JFrame frame;
    private JTextArea outputArea;
    private JButton saveButton;
    private JButton loadButton;
    private List<String> fechasValidas;
    private File selectedFile;

    public UI() {
        initialize();
    }

    private void initialize() {
        frame = new JFrame();
        frame.setTitle("Analizador de Fechas");
        frame.setBounds(100, 100, 500, 400);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.getContentPane().setLayout(new BorderLayout());

        outputArea = new JTextArea();
        outputArea.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(outputArea);
        frame.getContentPane().add(scrollPane, BorderLayout.CENTER);

        JPanel buttonPannel1 = new JPanel();
        frame.getContentPane().add(buttonPannel1, BorderLayout.SOUTH);

        saveButton = new JButton("Guardar Fechas");
        loadButton = new JButton("Seleccionar archivo");
        buttonPannel1.add(loadButton);
        buttonPannel1.add(saveButton);

        loadButton.addActionListener( new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                selectFileToAnalyze();
            }
        });

        saveButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                guardarFechas();
            }
        });

        frame.setVisible(true);

//        procesarArchivo();
    }

    private void selectFileToAnalyze(){
        JFileChooser fileChoose = new JFileChooser();
        int opt = fileChoose.showOpenDialog(frame);
        if (opt == JFileChooser.APPROVE_OPTION) {
            selectedFile = fileChoose.getSelectedFile();
            System.out.println(selectedFile + "nombre del archivo?");
            outputArea.setText("");
            procesarArchivo(selectedFile);
        }
    }

    private void procesarArchivo(File file) {
        try {
            DateLexer lexer = new DateLexer(new FileReader(file));
            System.out.println(lexer + "que el lexer");
            String token;
            while ((token = lexer.yylex()) != null) {
                // Since we return tokens with appended text, we can display them here
                System.out.println("Found valid date: " + token);
                outputArea.append(token + "\n");
            }
            fechasValidas = lexer.getFechasValidas();
            System.out.println(fechasValidas + " fechas validas");

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void guardarFechas() {
        JFileChooser fileChooser = new JFileChooser();
        int option = fileChooser.showSaveDialog(frame);
        if (option == JFileChooser.APPROVE_OPTION) {
            File file = fileChooser.getSelectedFile();
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (String fecha : fechasValidas) {
                    writer.write(fecha);
                    writer.newLine();
                }
                JOptionPane.showMessageDialog(frame, "Fechas guardadas exitosamente.");
            } catch (IOException e) {
                e.printStackTrace();
                JOptionPane.showMessageDialog(frame, "Error al guardar el archivo.", "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new UI());
    }
}
