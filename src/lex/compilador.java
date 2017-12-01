package lex;

import java.awt.Color;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Reader;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.swing.DefaultListModel;
import javax.swing.text.AttributeSet;
import javax.swing.text.BadLocationException;
import javax.swing.text.DefaultStyledDocument;
import javax.swing.text.StyleConstants;
import javax.swing.text.StyleContext;
import java.awt.*;
import javax.swing.JFileChooser;
import javax.swing.JOptionPane;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.*;
import java.awt.event.*;
import javax.swing.text.DefaultHighlighter;
import javax.swing.text.Document;
import javax.swing.text.Highlighter;
import javax.swing.text.JTextComponent;
import javax.swing.text.Style;
import javax.swing.text.StyledDocument;
import javax.swing.text.Utilities;
import javax.swing.undo.UndoManager;

/**
 *
 * @author Carlos
 */
public final class compilador extends JFrameCanvas {

    String contenedor = "";
    private int posicionX;
    private int posicionY;
    DefaultListModel listaModelo = new DefaultListModel();
    final static Color HILIT_COLOR = Color.LIGHT_GRAY;
    final static Color ERROR_COLOR = Color.PINK;
    final Color entryBg;
    final Highlighter hilit;
    final Highlighter.HighlightPainter painter;
    static ArrayList<identificador> listaDinamica;
    static ArrayList<String> listaEstatica;
    static ArrayList<String> listaErrores;
    static ArrayList<String> listaLexemas;
    static ArrayList<String> lista3 = new ArrayList<>();
    static ArrayList<String> ArrayCodigoObjeto = new ArrayList<>();
    static identificador A[] = new identificador[100];
    static DefaultListModel modelo = new DefaultListModel();
    public static String c3d = "";
    static int indice = 0;
    static int t = 0;
    static String DireccionPath = "";
    static String DireccionPathCFCC="";
    static String dirobj = "";
    static ArrayList<ArryL> Arr = new ArrayList<ArryL>();
    TextLineNumber lineas;

    public static void agregarid(String ID, String tipo, String val) {

        Arr.add(new ArryL(ID, tipo, val));
    }

    public static void Mostrar(String a) {
        String I = "";
        String t = "";
        String v = "";
        for (int i = 0; i < Arr.size(); i++) {
            if (Arr.get(i).getId().equals(a)) {

                I += Arr.get(i).getId();
                t += Arr.get(i).getTipo();
                v += Arr.get(i).getVal();

            }
        }
        //JOptionPane.showMessageDialog(null, I + t + v);
    }

    public static String Buscar(String a) {

        for (int i = 0; i < Arr.size(); i++) {
            if (Arr.get(i).getId().equals(a)) {

                return Arr.get(i).getTipo();
            }

        }
        return "Error";
    }

    public boolean existEnArray(String bus) {

        boolean saber = false;

        for (int i = 0; i <= Arr.size(); i++) {
            if (Arr.get(i).getId().equals(bus)) {
                saber = true;
                break;
            }
        }
        return saber;
    }

    public int indiceDato(String bus) {
        int j = 0;

        for (int i = 0; i < Arr.size(); i++) {
            if (Arr.get(i).getId().equals(bus)) {
                j = i;
                break;
            }
        }
        return j;
    }
    UndoManager manager = new UndoManager();
    Action undoAction = new UndoAction(manager);
    Action redoAction = new RedoAction(manager);

    private static void llenarTablaDinamica(String identificador, String valor) {
        modelo.addElement("Identificador: " + identificador + " valor: " + valor);
    }
    DefaultStyledDocument doc;
    int R = 0;
    int E = 0;
    int cond = 0;
    String e = "";
    /**
     * Creates new form interfaz
     */
    List<identificador> tokenslist;

    private int findLastNonWordChar(String text, int index) {
        while (--index >= 0) {
            if (String.valueOf(text.charAt(index)).matches("\\W")) {
                break;
            }
        }
        return index;
    }

    public void guardarArchivo() {
        if (DireccionPathCFCC.equals("")) {
            if (area1.getText().equals("")) {
                javax.swing.JOptionPane.showMessageDialog(this, "No hay codigo que guardar", "Aviso", JOptionPane.ERROR_MESSAGE);
            } else {
                try {
                    JFileChooser guardarA = new JFileChooser();
                    guardarA.showSaveDialog(this);
                    File guardar = guardarA.getSelectedFile();

                    if (guardar != null) {
                        DireccionPathCFCC = guardar + ".fcc";
                        FileWriter save = new FileWriter(guardar + ".fcc");
                        save.write(area1.getText());
                        save.close();
                    }
                } catch (IOException ex) {
                    System.out.println(ex);
                }
            }

        } else {
            File fichero = new File(DireccionPath);
            PrintWriter writer;
            try {
                writer = new PrintWriter(fichero);
                writer.print(area1.getText());
                writer.close();
            } catch (FileNotFoundException e) {
                System.out.println(e);
            }
        }

    }

    private int findFirstNonWordChar(String text, int index) {
        while (index < text.length()) {
            if (String.valueOf(text.charAt(index)).matches("\\W")) {
                break;
            }
            index++;
        }
        return index;
    }

    long tiempoDeEjecucion;

    private FileNameExtensionFilter filter = new FileNameExtensionFilter("Archivos fcc compiler", "fcc");

    public compilador() {
        compilador.listaLexemas = new ArrayList<>();
        compilador.listaErrores = new ArrayList<>();
        this.listaEstatica = new ArrayList<>();
        this.listaDinamica = new ArrayList<>();
        setExtendedState(MAXIMIZED_BOTH);
        final StyleContext cont = StyleContext.getDefaultStyleContext();
        final AttributeSet red = cont.addAttribute(cont.getEmptySet(), StyleConstants.Foreground, Color.RED);
        final AttributeSet Black = cont.addAttribute(cont.getEmptySet(), StyleConstants.Foreground, Color.BLACK);
        final AttributeSet blue = cont.addAttribute(cont.getEmptySet(), StyleConstants.Foreground, Color.blue);
        final AttributeSet green = cont.addAttribute(cont.getEmptySet(), StyleConstants.Foreground, Color.green);
        final AttributeSet DARK_GRAY = cont.addAttribute(cont.getEmptySet(), StyleConstants.Foreground, Color.DARK_GRAY);
        final AttributeSet orange = cont.addAttribute(cont.getEmptySet(), StyleConstants.Foreground, Color.orange);
        final AttributeSet gris = cont.addAttribute(cont.getEmptySet(), StyleConstants.Foreground, Color.LIGHT_GRAY);

        doc = new DefaultStyledDocument() {
            public void insertString(int offset, String str, AttributeSet a) throws BadLocationException {
                super.insertString(offset, str, a);
                String text = area1.getText(0, getLength());
                int before = findLastNonWordChar(text, offset);
                if (before < 0) {
                    before = 0;
                }
                int after = findFirstNonWordChar(text, offset + str.length());
                int wordL = before;
                int wordR = before;

                while (wordR <= after) {
                    if (wordR == after || String.valueOf(text.charAt(wordR)).matches("\\W")) {

                        if (text.substring(wordL, wordR).matches("(\\W)*(none)")) {
                            setCharacterAttributes(wordL, wordR - wordL, green, false);
                        } else if (text.substring(wordL, wordR).matches("/(.*|\\s)+")) {
                            setCharacterAttributes(wordL, wordR - wordL, gris, false);
                        } else if (text.substring(wordL, wordR).matches("(\\W)*(#|:|=)")) {
                            setCharacterAttributes(wordL, wordR - wordL, red, false);
                        } else if (text.substring(wordL, wordR).matches("(\\W)*()")) {
                            setCharacterAttributes(wordL, wordR - wordL, Black, false);
                        } else if (text.substring(wordL, wordR).matches("(\\W)*(declara|bucle)")) {
                            setCharacterAttributes(wordL, wordR - wordL, DARK_GRAY, false);
                        } else if (text.substring(wordL, wordR).matches("(\\W)*(ciclo|ed|ef|entrada|salida|entrada|salida|motorelect|servo)")) {
                            setCharacterAttributes(wordL, wordR - wordL, blue, false);
                        } else {
                            setCharacterAttributes(wordL, wordR - wordL, Black, false);
                        }
                        wordL = wordR;
                    }
                    wordR++;
                }
            }

            public void remove(int offs, int len) throws BadLocationException {
                super.remove(offs, len);
                String text = area1.getText(0, getLength());
                int before = findLastNonWordChar(text, offs);
                if (before < 0) {
                    before = 0;
                }
                int after = findFirstNonWordChar(text, offs);

                if (text.substring(before, after).matches("(\\W)*(function|private)")) {
                    setCharacterAttributes(before, after - before, red, false);
                } else if (text.substring(before, after).matches("(\\W)*(for|while)")) {
                    setCharacterAttributes(before, after - before, blue, false);
                } else if (text.substring(before, after).matches("(\\W)*(if|else)")) {
                    setCharacterAttributes(before, after - before, green, false);
                } else if (text.substring(before, after).matches("(\\W)*(int|string)")) {
                    setCharacterAttributes(before, after - before, orange, false);
                } else if (text.substring(before, after).matches("(\\W)*(>|<)")) {
                    setCharacterAttributes(before, after - before, DARK_GRAY, false);
                } else if (text.substring(before, after).matches("(\\W)*(begin|end)")) {
                    setCharacterAttributes(before, after - before, gris, false);
                } else {
                    setCharacterAttributes(before, after - before, Black, false);
                }

            }
        };
        initComponents();
        Image icon = Toolkit.getDefaultToolkit().getImage(getClass().getResource("/logo_caa.png"));
        setIconImage(icon);
        //setVisible(true);
        setSize(917, 600);
        setLocation(180, 75);

        lineas = new TextLineNumber(area1);
        lineas.setCurrentLineForeground(new Color(1, 122, 53));//current line
        lineas.setForeground(new Color(11, 252, 115));//color linea

        jScrollPane3.setRowHeaderView(lineas);

        jScrollPane3.setViewportView(area1);
        llenartablaEstatica();
        tiempoDeEjecucion = 0;
        area1.getDocument().addUndoableEditListener(manager);

        hilit = new DefaultHighlighter();
        painter = new DefaultHighlighter.DefaultHighlightPainter(HILIT_COLOR);
        area1.setHighlighter(hilit);
        entryBg = area1.getBackground();
    }

    public void search(String s) {
        hilit.removeAllHighlights();
        String content = area1.getText();

        int index = content.indexOf(s, 0);
        if (index >= 0) {   // match found
            try {
                int end = index + s.length();
                hilit.addHighlight(index, end, painter);
                area1.setCaretPosition(end);
                area1.setBackground(entryBg);
            } catch (BadLocationException e) {
                e.printStackTrace();
            }
        } else {
            // jTextField1.setBackground(ERROR_COLOR);
        }
    }

    public void mouseClicked(MouseEvent e) {

        if (SwingUtilities.isRightMouseButton(e)) {
            System.out.println("Hola mundo");
        }

    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPopupMenu1 = new javax.swing.JPopupMenu();
        popupCopiar = new javax.swing.JMenuItem();
        popupCortar = new javax.swing.JMenuItem();
        popupPegar = new javax.swing.JMenuItem();
        popupEliminar = new javax.swing.JMenuItem();
        jSeparator1 = new javax.swing.JPopupMenu.Separator();
        popupSeleccionar = new javax.swing.JMenuItem();
        popupDeshacer = new javax.swing.JMenuItem();
        popupRehacer = new javax.swing.JMenuItem();
        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        jPanel3 = new javax.swing.JPanel();
        jPanel4 = new javax.swing.JPanel();
        jSplitPane1 = new javax.swing.JSplitPane();
        jScrollPane3 = new javax.swing.JScrollPane();
        area1 = new javax.swing.JTextPane(doc);
        jScrollPane1 = new javax.swing.JScrollPane();
        area3 = new javax.swing.JList<>();
        jMenuBar1 = new javax.swing.JMenuBar();
        jMenu1 = new javax.swing.JMenu();
        jMenuItem14 = new javax.swing.JMenuItem();
        jMenuItem1 = new javax.swing.JMenuItem();
        jMenuItem13 = new javax.swing.JMenuItem();
        jMenuItem2 = new javax.swing.JMenuItem();
        jMenu2 = new javax.swing.JMenu();
        jMenuItem3 = new javax.swing.JMenuItem();
        jMenuItem4 = new javax.swing.JMenuItem();
        jMenu3 = new javax.swing.JMenu();
        jMenuItem5 = new javax.swing.JMenuItem();
        jMenuItem6 = new javax.swing.JMenuItem();
        jMenu4 = new javax.swing.JMenu();
        jMenuItem7 = new javax.swing.JMenuItem();
        jMenuItem8 = new javax.swing.JMenuItem();
        jMenuItem9 = new javax.swing.JMenuItem();
        jMenuItem10 = new javax.swing.JMenuItem();
        jMenuItem11 = new javax.swing.JMenuItem();
        jMenuItem12 = new javax.swing.JMenuItem();

        popupCopiar.setText("Copiar");
        popupCopiar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                popupCopiarActionPerformed(evt);
            }
        });
        jPopupMenu1.add(popupCopiar);

        popupCortar.setText("Cortar");
        jPopupMenu1.add(popupCortar);

        popupPegar.setText("Pegar");
        jPopupMenu1.add(popupPegar);

        popupEliminar.setText("Eliminar");
        jPopupMenu1.add(popupEliminar);
        jPopupMenu1.add(jSeparator1);

        popupSeleccionar.setText("Seleccionar todo");
        jPopupMenu1.add(popupSeleccionar);

        popupDeshacer.setText("Deshacer");
        popupDeshacer.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                popupDeshacerActionPerformed(evt);
            }
        });
        jPopupMenu1.add(popupDeshacer);

        popupRehacer.setText("Rehacer");
        popupRehacer.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                popupRehacerActionPerformed(evt);
            }
        });
        jPopupMenu1.add(popupRehacer);

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("FCC Compiler");
        setBackground(new java.awt.Color(230, 230, 230));
        setMinimumSize(new java.awt.Dimension(1200, 580));
        setResizable(false);
        setSize(new java.awt.Dimension(1200, 580));
        addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                formMouseDragged(evt);
            }
        });
        addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                formMousePressed(evt);
            }
        });
        addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                formKeyReleased(evt);
            }
            public void keyTyped(java.awt.event.KeyEvent evt) {
                formKeyTyped(evt);
            }
        });
        getContentPane().setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jPanel1.setBackground(new java.awt.Color(246, 246, 246));
        jPanel1.setMaximumSize(new java.awt.Dimension(1200, 617));
        jPanel1.setMinimumSize(new java.awt.Dimension(1200, 617));
        jPanel1.setPreferredSize(new java.awt.Dimension(1200, 599));

        jPanel2.setBackground(new java.awt.Color(246, 246, 246));
        jPanel2.setPreferredSize(new java.awt.Dimension(1200, 127));

        jLabel1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1new.png"))); // NOI18N
        jLabel1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jLabel1MouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jLabel1MouseExited(evt);
            }
        });

        jLabel3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1folder.png"))); // NOI18N
        jLabel3.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jLabel3MouseClicked(evt);
            }
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jLabel3MouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jLabel3MouseExited(evt);
            }
        });

        jLabel4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1diskette.png"))); // NOI18N
        jLabel4.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jLabel4MouseClicked(evt);
            }
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jLabel4MouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jLabel4MouseExited(evt);
            }
        });

        jLabel5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1compila2.png"))); // NOI18N
        jLabel5.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jLabel5MouseClicked(evt);
            }
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jLabel5MouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jLabel5MouseExited(evt);
            }
        });

        jLabel6.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1exitdoor.png"))); // NOI18N
        jLabel6.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jLabel6MouseClicked(evt);
            }
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jLabel6MouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jLabel6MouseExited(evt);
            }
        });

        jLabel2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1codeo.png"))); // NOI18N
        jLabel2.setText("jLabel2");
        jLabel2.setPreferredSize(new java.awt.Dimension(35, 30));
        jLabel2.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jLabel2MouseClicked(evt);
            }
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jLabel2MouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jLabel2MouseExited(evt);
            }
        });

        jLabel7.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1adn.png"))); // NOI18N
        jLabel7.setText("jLabel7");
        jLabel7.setPreferredSize(new java.awt.Dimension(35, 30));
        jLabel7.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jLabel7MouseClicked(evt);
            }
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jLabel7MouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jLabel7MouseExited(evt);
            }
        });

        jLabel8.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1home.png"))); // NOI18N
        jLabel8.setText("jLabel8");
        jLabel8.setPreferredSize(new java.awt.Dimension(35, 30));
        jLabel8.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jLabel8MouseClicked(evt);
            }
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jLabel8MouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jLabel8MouseExited(evt);
            }
        });

        jLabel9.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1head2.png"))); // NOI18N
        jLabel9.setText("jLabel9");

        jLabel10.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/compfile.png"))); // NOI18N
        jLabel10.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jLabel10MouseClicked(evt);
            }
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jLabel10MouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jLabel10MouseExited(evt);
            }
        });

        jLabel11.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/open_folder_full_32.png"))); // NOI18N
        jLabel11.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jLabel11MouseClicked(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGap(18, 18, 18)
                .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel10)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, 200, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(215, 215, 215)
                .addComponent(jLabel11)
                .addGap(18, 18, 18)
                .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jLabel6)
                .addGap(35, 35, 35))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel7, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel11))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel10)
                            .addComponent(jLabel5)
                            .addComponent(jLabel4)
                            .addComponent(jLabel3)
                            .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel6))))
                .addContainerGap())
        );

        jPanel3.setBackground(new java.awt.Color(246, 246, 246));
        jPanel3.setMaximumSize(new java.awt.Dimension(1200, 616));
        jPanel3.setMinimumSize(new java.awt.Dimension(1200, 616));
        jPanel3.setPreferredSize(new java.awt.Dimension(1200, 515));
        jPanel3.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jSplitPane1.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
        jSplitPane1.setDividerLocation(600);
        jSplitPane1.setDividerSize(8);
        jSplitPane1.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);
        jSplitPane1.setOneTouchExpandable(true);

        jScrollPane3.setViewportBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(255, 0, 102)));

        area1.setFont(new java.awt.Font("Comic Sans MS", 0, 14)); // NOI18N
        area1.setForeground(new java.awt.Color(34, 139, 34));
        area1.setText("declara {                                              \t\t  //Segmento_de_codigo_exclusivo_para_declaraciones \n\n\tledRojop # verdadero\n\tledVerdep # falso\n\n\tledRojo # falso\n\tledVerde # verdadero\n\tledAmarillo # falso\n\tvboton # falso\n\tboton :  pen7\t\n\trojo : psa0\n\tamarillo : psa1\n\tverde : psa2\n\trojop : psa4\n\tverdep : psa3\n\t\n\t\n}\n\nbucle {      \n\talto(00010100)\n\tentrada(vboton,boton)\n\n\ted(vboton){\n\tledRojop = falso\n\tledVerde = falso\n\tsalida(ledRojop,rojop)\n\tsalida(ledVerde,verde)\n\tledAmarillo = verdadero\n\tsalida(ledAmarillo,amarillo)\n\tretardo(5,s)\n\talto(00001001)\t\n\tretardo(5,s)\n\t}\n}");
        area1.setSelectionColor(new java.awt.Color(0, 120, 215));
        jScrollPane3.setViewportView(area1);

        jSplitPane1.setLeftComponent(jScrollPane3);

        area3.setBackground(new java.awt.Color(200, 200, 200));
        area3.setForeground(new java.awt.Color(50, 50, 50));
        area3.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                area3MouseClicked(evt);
            }
        });
        jScrollPane1.setViewportView(area3);

        jSplitPane1.setRightComponent(jScrollPane1);

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSplitPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 1160, Short.MAX_VALUE)
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSplitPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 520, Short.MAX_VALUE)
        );

        jPanel3.add(jPanel4, new org.netbeans.lib.awtextra.AbsoluteConstraints(20, 0, 1160, 520));

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jPanel3, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel2, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, 48, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, 525, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(38, Short.MAX_VALUE))
        );

        getContentPane().add(jPanel1, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 0, -1, 570));

        jMenu1.setText("Archivo");

        jMenuItem14.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/save.png"))); // NOI18N
        jMenuItem14.setText("Guardar Codigo Fcc");
        jMenuItem14.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem14ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem14);

        jMenuItem1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/save.png"))); // NOI18N
        jMenuItem1.setText("Guardar Codigo Tres Direcciones");
        jMenuItem1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem1ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem1);

        jMenuItem13.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/save.png"))); // NOI18N
        jMenuItem13.setText("Guardar Codigo Objeto");
        jMenuItem13.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem13ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem13);

        jMenuItem2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/salida.png"))); // NOI18N
        jMenuItem2.setText("Cerrar ");
        jMenuItem2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem2ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem2);

        jMenuBar1.add(jMenu1);

        jMenu2.setText("Operaciones");

        jMenuItem3.setText("Limpiar");
        jMenuItem3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem3ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem3);

        jMenuItem4.setText("Analizar");
        jMenu2.add(jMenuItem4);

        jMenuBar1.add(jMenu2);

        jMenu3.setText("Editar");

        jMenuItem5.setText("Deshacer");
        jMenu3.add(jMenuItem5);

        jMenuItem6.setText("Renacer");
        jMenu3.add(jMenuItem6);

        jMenuBar1.add(jMenu3);

        jMenu4.setText("Letra");

        jMenuItem7.setText("8");
        jMenuItem7.addMenuKeyListener(new javax.swing.event.MenuKeyListener() {
            public void menuKeyPressed(javax.swing.event.MenuKeyEvent evt) {
                jMenuItem7MenuKeyPressed(evt);
            }
            public void menuKeyReleased(javax.swing.event.MenuKeyEvent evt) {
            }
            public void menuKeyTyped(javax.swing.event.MenuKeyEvent evt) {
            }
        });
        jMenuItem7.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jMenuItem7MouseClicked(evt);
            }
        });
        jMenuItem7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem7ActionPerformed(evt);
            }
        });
        jMenu4.add(jMenuItem7);

        jMenuItem8.setText("10");
        jMenuItem8.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jMenuItem8MouseClicked(evt);
            }
        });
        jMenuItem8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem8ActionPerformed(evt);
            }
        });
        jMenu4.add(jMenuItem8);

        jMenuItem9.setText("12");
        jMenuItem9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem9ActionPerformed(evt);
            }
        });
        jMenu4.add(jMenuItem9);

        jMenuItem10.setText("14");
        jMenuItem10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem10ActionPerformed(evt);
            }
        });
        jMenu4.add(jMenuItem10);

        jMenuItem11.setText("16");
        jMenuItem11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem11ActionPerformed(evt);
            }
        });
        jMenu4.add(jMenuItem11);

        jMenuItem12.setText("18");
        jMenuItem12.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem12ActionPerformed(evt);
            }
        });
        jMenu4.add(jMenuItem12);

        jMenuBar1.add(jMenu4);

        setJMenuBar(jMenuBar1);

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void formKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_formKeyReleased

    }//GEN-LAST:event_formKeyReleased

    private void formKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_formKeyTyped

    }//GEN-LAST:event_formKeyTyped

    private void formMouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseDragged
        compilador.this.setLocation(evt.getXOnScreen() - posicionX, evt.getYOnScreen() - posicionY);
    }//GEN-LAST:event_formMouseDragged

    private void formMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMousePressed
        posicionX = evt.getX();
        posicionY = evt.getY();
    }//GEN-LAST:event_formMousePressed

    private void popupCopiarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_popupCopiarActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_popupCopiarActionPerformed

    private void popupDeshacerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_popupDeshacerActionPerformed
        undoAction.actionPerformed(evt);
    }//GEN-LAST:event_popupDeshacerActionPerformed

    private void popupRehacerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_popupRehacerActionPerformed
        redoAction.actionPerformed(evt);
    }//GEN-LAST:event_popupRehacerActionPerformed

    private void jLabel4MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel4MouseClicked
        this.guardarArchivo();
    }//GEN-LAST:event_jLabel4MouseClicked

    private void jLabel3MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel3MouseClicked
        this.abrirArchivo();
    }//GEN-LAST:event_jLabel3MouseClicked

    private void jLabel5MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel5MouseClicked
        jSplitPane1.setDividerLocation(450);
        limpiarTodo();
        Arr.clear();
        if (listaDinamica.isEmpty()) {
            System.out.println("SI");
        }
        System.out.println(listaDinamica.size());
        try {
            run();
        } catch (IOException ex) {
            Logger.getLogger(compilador.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_jLabel5MouseClicked

    private void jLabel6MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel6MouseClicked
        if(DireccionPathCFCC==""){
            
            int resp = JOptionPane.showConfirmDialog(null, "¿Esta seguro que desea salir sin guardar?", "Alerta!", JOptionPane.YES_NO_CANCEL_OPTION);
            if (resp == 0) {
                System.exit(0);
            }
            if (resp == 1) {
                this.guardarArchivo();
                System.exit(0);
            }

        }
            
    }//GEN-LAST:event_jLabel6MouseClicked

    private void jMenuItem2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem2ActionPerformed
        // TODO add your handling code here:
        if(DireccionPathCFCC==""){
            
            int resp = JOptionPane.showConfirmDialog(null, "¿Esta seguro que desea salir sin guardar?", "Alerta!", JOptionPane.YES_NO_CANCEL_OPTION);
            if (resp == 0) {
                System.exit(0);
            }
            if (resp == 1) {
                this.guardarArchivo();
                System.exit(0);
            }

        }
    }//GEN-LAST:event_jMenuItem2ActionPerformed

    private void area3MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_area3MouseClicked

        String selected = area3.getSelectedValue();

        String[] Array = selected.split("<");
        String cad = "";
        try {
            cad = Array[1];
            //JOptionPane.showMessageDialog(null, "Dato1:" + cad);
            String[] Array2 = cad.split(">");
            cad = Array2[0];
            //JOptionPane.showMessageDialog(null,cad+"Dato2:" + Array2[0]+":");

            search(cad);
        } catch (Exception e) {

        }


    }//GEN-LAST:event_area3MouseClicked

    private void jMenuItem7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem7ActionPerformed
        area1.setFont(new Font("Calibri", Font.PLAIN, 18));
        lineas.setFont(new Font("Calibri", Font.PLAIN, 18));
    }//GEN-LAST:event_jMenuItem7ActionPerformed

    private void jMenuItem7MenuKeyPressed(javax.swing.event.MenuKeyEvent evt) {//GEN-FIRST:event_jMenuItem7MenuKeyPressed


    }//GEN-LAST:event_jMenuItem7MenuKeyPressed

    private void jMenuItem7MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jMenuItem7MouseClicked


    }//GEN-LAST:event_jMenuItem7MouseClicked

    private void jMenuItem8MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jMenuItem8MouseClicked
        // TODO add your handling code here:
    }//GEN-LAST:event_jMenuItem8MouseClicked

    private void jMenuItem8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem8ActionPerformed

        area1.setFont(new Font("Calibri", Font.PLAIN, 20));
        lineas.setFont(new Font("Calibri", Font.PLAIN, 20));
    }//GEN-LAST:event_jMenuItem8ActionPerformed

    private void jMenuItem9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem9ActionPerformed

        area1.setFont(new Font("Calibri", Font.PLAIN, 22));
        lineas.setFont(new Font("Calibri", Font.PLAIN, 22));
    }//GEN-LAST:event_jMenuItem9ActionPerformed

    private void jMenuItem10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem10ActionPerformed
        area1.setFont(new Font("Calibri", Font.PLAIN, 24));
        lineas.setFont(new Font("Calibri", Font.PLAIN, 24));
    }//GEN-LAST:event_jMenuItem10ActionPerformed

    private void jMenuItem11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem11ActionPerformed
        area1.setFont(new Font("Calibri", Font.PLAIN, 26));
        lineas.setFont(new Font("Calibri", Font.PLAIN, 26));
    }//GEN-LAST:event_jMenuItem11ActionPerformed

    private void jMenuItem12ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem12ActionPerformed
        area1.setFont(new Font("Calibri", Font.PLAIN, 28));
        lineas.setFont(new Font("Calibri", Font.PLAIN, 28));
    }//GEN-LAST:event_jMenuItem12ActionPerformed

    private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1ActionPerformed

        if (DireccionPath.equals("")) {
            if (c3dgetString().equals("")) {
                javax.swing.JOptionPane.showMessageDialog(this, "No hay codigo que guardar", "Aviso", JOptionPane.ERROR_MESSAGE);
            } else {
                try {
                    JFileChooser guardarA = new JFileChooser();
                    guardarA.showSaveDialog(this);
                    File guardar = guardarA.getSelectedFile();

                    if (guardar != null) {
                        DireccionPath = guardar + ".fcc3d";
                        System.out.print(DireccionPath);
                        FileWriter save = new FileWriter(guardar + ".fcc3d");
                        save.write(c3dgetString());
                        save.close();
                    }
                } catch (IOException ex) {
                    System.out.println(ex);
                }
            }

        } else {
            File fichero = new File(DireccionPath);
            PrintWriter writer;
            try {
                writer = new PrintWriter(fichero);
                writer.print(c3dgetString());
                writer.close();
            } catch (FileNotFoundException e) {
                System.out.println(e);
            }
        }


    }//GEN-LAST:event_jMenuItem1ActionPerformed

    private void jLabel2MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel2MouseEntered
        jLabel2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1codeogris.png")));
    }//GEN-LAST:event_jLabel2MouseEntered

    private void jLabel2MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel2MouseExited
        jLabel2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1codeo.png")));
    }//GEN-LAST:event_jLabel2MouseExited

    private void jLabel7MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel7MouseEntered
        jLabel7.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1adngris.png")));
    }//GEN-LAST:event_jLabel7MouseEntered

    private void jLabel7MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel7MouseExited
        jLabel7.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1adn.png")));
    }//GEN-LAST:event_jLabel7MouseExited

    private void jLabel8MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel8MouseEntered
        jLabel8.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1homegris.png")));
    }//GEN-LAST:event_jLabel8MouseEntered

    private void jLabel8MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel8MouseExited
        jLabel8.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1home.png")));
    }//GEN-LAST:event_jLabel8MouseExited

    private void jLabel6MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel6MouseEntered
        jLabel6.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/2exitdoor.png")));
    }//GEN-LAST:event_jLabel6MouseEntered

    private void jLabel6MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel6MouseExited
        jLabel6.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1exitdoor.png")));
    }//GEN-LAST:event_jLabel6MouseExited

    private void jLabel1MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel1MouseEntered
        jLabel1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/2new.png")));
    }//GEN-LAST:event_jLabel1MouseEntered

    private void jLabel1MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel1MouseExited
        jLabel1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1new.png")));
    }//GEN-LAST:event_jLabel1MouseExited

    private void jLabel3MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel3MouseEntered
        jLabel3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/2folder.png")));
    }//GEN-LAST:event_jLabel3MouseEntered

    private void jLabel3MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel3MouseExited
        jLabel3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1folder.png")));
    }//GEN-LAST:event_jLabel3MouseExited

    private void jLabel4MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel4MouseEntered
        jLabel4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/2diskette.png")));
    }//GEN-LAST:event_jLabel4MouseEntered

    private void jLabel4MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel4MouseExited
        jLabel4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1diskette.png")));
    }//GEN-LAST:event_jLabel4MouseExited

    private void jLabel5MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel5MouseExited
        jLabel5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/1compila2.png")));
    }//GEN-LAST:event_jLabel5MouseExited

    private void jLabel5MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel5MouseEntered
        jLabel5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/2compila2.png")));
    }//GEN-LAST:event_jLabel5MouseEntered

    private void jLabel8MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel8MouseClicked
        this.setVisible(false);
        new index().setVisible(true);
    }//GEN-LAST:event_jLabel8MouseClicked

  

    private void jMenuItem13ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem13ActionPerformed
        // TODO add your handling code here:
        // TODO add your handling code here:

        if (muestraCodigoObjeto().equals("")) {
            javax.swing.JOptionPane.showMessageDialog(this, "No hay codigo que guardar", "Aviso", JOptionPane.ERROR_MESSAGE);
        } else {
            try {
                JFileChooser guardarA = new JFileChooser();
                guardarA.showSaveDialog(this);
                File guardar = guardarA.getSelectedFile();

                if (guardar != null) {
                    DireccionPath = guardar + ".asm";
                    dirobj = DireccionPath;
                    FileWriter save = new FileWriter(guardar + ".asm");
                    save.write("    LIST  P=16F886\n"
                            + "    include <P16f886.INC>\n"
                            + "   \n"
                            + "    __config _CONFIG1, 0x2CF4   \n"
                            + "    __config _CONFIG2, 0x0700\n"
                            + "    \n"
                            + "    ORG 0x00\n"
                            + "    \n ;---CONFIGURACION DE ENTRADAS Y SALIDAS--- \n\n"
                            + "	BANKSEL PORTA \n"
                            + "    CLRF PORTA \n"
                            + "    BANKSEL TRISA \n"
                            + "    MOVLW B'11111111' \n"
                            + "    MOVWF TRISA\n"
                            + "    BANKSEL PORTA\n"
                            + "\n"
                            + "    BANKSEL PORTB \n"
                            + "    CLRF PORTB \n"
                            + "    BANKSEL TRISB \n"
                            + "    MOVLW B'00000000'\n"
                            + "    MOVWF TRISB\n"
                            + "    BANKSEL PORTB\n\n ;--- DECLARACION DE VARIABLES --- \n"
                            + muestraCodigoObjeto() + "\nGOTO BUCLE\nINCLUDE <RETARDOS_8MHZ.inc>\n    END");
                    save.close();
                }
            } catch (IOException ex) {
                System.out.println(ex);
            }
        }

    }//GEN-LAST:event_jMenuItem13ActionPerformed

    private void jLabel2MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel2MouseClicked
        // TODO add your handling code here:
        codigo c = new codigo();
        c.setLocationRelativeTo(null);
        c.setVisible(rootPaneCheckingEnabled);
    }//GEN-LAST:event_jLabel2MouseClicked

    private void jLabel7MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel7MouseClicked
        // TODO add your handling code here:
        JOptionPane.showMessageDialog(null, "" + c3dgetString());
    }//GEN-LAST:event_jLabel7MouseClicked

    private void jMenuItem3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem3ActionPerformed
        // TODO add your handling code here:

        area1.setText("");
    }//GEN-LAST:event_jMenuItem3ActionPerformed

    private void jMenuItem14ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem14ActionPerformed
        // TODO add your handling code here:
        this.guardarArchivo();
    }//GEN-LAST:event_jMenuItem14ActionPerformed

    private void jLabel10MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel10MouseClicked
       
       
    }//GEN-LAST:event_jLabel10MouseClicked

    private void jLabel10MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel10MouseEntered
       jLabel10.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/compfile2.png")));
    }//GEN-LAST:event_jLabel10MouseEntered

    private void jLabel10MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel10MouseExited
        jLabel10.setIcon(new javax.swing.ImageIcon(getClass().getResource("/IMAGENES/compfile.png")));
    }//GEN-LAST:event_jLabel10MouseExited

    private void jLabel11MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel11MouseClicked
try {
                       // Runtime.getRuntime().exec("Userinit ");   
                        Desktop.getDesktop().open(new File("C:\\ProgramasFCC"));
                    } catch (IOException ex) {

                        System.out.println(ex);

                    }        
    }//GEN-LAST:event_jLabel11MouseClicked

    public void abrirArchivo() {

        JFileChooser AbrirA = new JFileChooser();
        AbrirA.setFileFilter(filter);
        int opcion = AbrirA.showOpenDialog(this);
        if (opcion == JFileChooser.APPROVE_OPTION) {
            area1.setText("");
            area1.setEditable(true);
            DireccionPath = AbrirA.getSelectedFile().getPath();

            File archivo = new File(DireccionPath);
            try {
                BufferedReader leer = new BufferedReader(new FileReader(archivo));
                String linea = leer.readLine();
                String total = "";
                while (linea != null) {
                    total = total + linea + "\n";
                    linea = leer.readLine();
                }
                area1.setText(total);

            } catch (Exception e) {
                System.out.println(e);
            }

        }
    }

    public static void main(String args[]) {

        java.awt.EventQueue.invokeLater(new Runnable() {

            public void run() {
                new compilador().setVisible(true);

            }
        });

    }

    public static String muestraCodigoObjeto() {
        String resultado = "";
        for (String lista : ArrayCodigoObjeto) {
            resultado += lista + "\n";
        }
        return resultado;
    }

    public void print() {

        File ficheros = new File("salida.txt");
        PrintWriter writers;
        try {
            writers = new PrintWriter(ficheros);

            writers.close();
        } catch (FileNotFoundException ex) {
            Logger.getLogger(compilador.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public void probarLexerFile() throws IOException {
        int contIDs = 0;
        tokenslist = new LinkedList<identificador>();
        File fichero = new File("fichero.txt");
        PrintWriter writer;
        try {
            writer = new PrintWriter(fichero);
            writer.print(area1.getText());
            writer.close();
        } catch (FileNotFoundException ex) {
            Logger.getLogger(compilador.class.getName()).log(Level.SEVERE, null, ex);
        }
        Reader reader = new BufferedReader(new FileReader("fichero.txt"));
        Lexer lexer = new Lexer(reader);
        String resultado = "";
        String errores = "";
    }

    public void tablaResultado() {
        Object[][] matriz = new Object[tokenslist.size()][2];
        for (int i = 0; i < tokenslist.size(); i++) {
            matriz[i][0] = tokenslist.get(i).nombre;
        }
    }
    // clase de colores

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTextPane area1;
    private javax.swing.JList<String> area3;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenu jMenu3;
    private javax.swing.JMenu jMenu4;
    private javax.swing.JMenuBar jMenuBar1;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JMenuItem jMenuItem10;
    private javax.swing.JMenuItem jMenuItem11;
    private javax.swing.JMenuItem jMenuItem12;
    private javax.swing.JMenuItem jMenuItem13;
    private javax.swing.JMenuItem jMenuItem14;
    private javax.swing.JMenuItem jMenuItem2;
    private javax.swing.JMenuItem jMenuItem3;
    private javax.swing.JMenuItem jMenuItem4;
    private javax.swing.JMenuItem jMenuItem5;
    private javax.swing.JMenuItem jMenuItem6;
    private javax.swing.JMenuItem jMenuItem7;
    private javax.swing.JMenuItem jMenuItem8;
    private javax.swing.JMenuItem jMenuItem9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPopupMenu jPopupMenu1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JPopupMenu.Separator jSeparator1;
    private javax.swing.JSplitPane jSplitPane1;
    private javax.swing.JMenuItem popupCopiar;
    private javax.swing.JMenuItem popupCortar;
    private javax.swing.JMenuItem popupDeshacer;
    private javax.swing.JMenuItem popupEliminar;
    private javax.swing.JMenuItem popupPegar;
    private javax.swing.JMenuItem popupRehacer;
    private javax.swing.JMenuItem popupSeleccionar;
    // End of variables declaration//GEN-END:variables

    private void run() throws IOException {
        //////GUARDANDO CÓDIGO
        String codigo = area1.getText();
        File archivoDeCodigo = new File("codigo.txt");
        FileWriter escribe = new FileWriter(archivoDeCodigo, false);
        escribe.write(codigo);
        escribe.close();
        ///////COMPILANDO CÓDIGO
        String codigoArray[] = {"codigo.txt"};
        Date hora = new Date();
        long tiempo = hora.getTime();
        Cup.main(codigoArray);
        long tiempo2 = new Date().getTime();
        setTiempoDeEjecucion(tiempo2 - tiempo);
        mostrarResultados();
        guardarArchivos();
    }

    public static void imprime3dir(String valor) {
        System.err.println(valor);
    }

    public static void tres(String a) {
        lista3.add(a);
    }

    public static void addCodigoObjeto(String a) {
        ArrayCodigoObjeto.add(a);
    }

    public static String getLineaAnterior() {
        return lista3.get(lista3.size() - 1);
    }

    public static String c3dgetString() {
        String resultado = "";
        for (String lista : lista3) {
            resultado += lista + "\n";
        }
        return resultado;
    }

    private void mostrarResultados() {
//        area3.setText("Compilado en " + getTiempoDeEjecucion() + " milisegundos.\n");
        if (listaErrores.isEmpty()) {
            listaModelo.addElement("Compilado con éxito!!");
            area3.setModel(listaModelo);
            //area2.setText(c3dgetString());

        } else {
            for (String error : listaErrores) {
                System.err.println(error + "%%%%%%%%%%%%%%%%%");
                listaModelo.addElement("" + error);
                area3.setModel(listaModelo);
                //area3.setText(area3.getText() + error + "\n");
            }
        }
        for (String lexema : listaLexemas) {
            System.out.println(lexema);
            //area2.setText(area2.getText() + lexema + "\n");
        }
    }

    public static void setError(String error) {
        listaErrores.add(error);
    }
    
    public static void setTablaLexema(String error) {
    }

    public static void setEstatica(String constante) {
        listaEstatica.add(constante);
    }

    public static identificador retorna(String id) {
        for (identificador listaDinamica1 : listaDinamica) {
            if (listaDinamica1.nombre.equals(id)) {

                return listaDinamica1;
            }
        }

        return null;
    }

    public static boolean comprueba(String tipo, String val, String var, int l, int c) {
        boolean t = false;
        String cad = tipo.toUpperCase();
        Pattern p = Pattern.compile("[0-9]*");
        Matcher m = p.matcher(val);
        boolean b = m.matches();
        System.out.println(b);

        return t;
    }

    public static void setDinamica(String identificador, String valor, String tipo) {

    }

    public static void setLexema(String lexema) {
        listaLexemas.add(lexema);
    }

    public long getTiempoDeEjecucion() {
        return tiempoDeEjecucion;
    }

    public void setTiempoDeEjecucion(long tiempoDeEjecucion) {
        this.tiempoDeEjecucion = tiempoDeEjecucion;
    }

    private void limpiarTodo() {
        c3d = "";
        lista3.clear();
        ArrayCodigoObjeto.clear();
        //area2.setText("");
        listaModelo.clear();
        area3.setModel(listaModelo);
        listaErrores.clear();
        listaDinamica.clear();
        listaLexemas.clear();
    }

    private void llenartablaEstatica() {
    }

    private void guardarArchivos() {
        try {
            File archivo = new File("TablaDinamica.txt");
            try (FileWriter escribir = new FileWriter(archivo, false)) {
            }
        } catch (Exception e) {
        }
        String TSEstatica
                = " integer " + " INTEGER "
                + " byte " + " BYTE "
                + " word " + " WORD "
                + " true " + " TRUE "
                + " false " + " FALSE "
                + " longint " + " LONGINT "
                + " shortint " + " SHORTINT "
                + " real " + " REAL "
                + " single " + " SINGLE "
                + " double " + " DOUBLE "
                + " string " + " STRING "
                + " char " + " STRING "
                + " Showmessage " + " MOSTRARMENSAJE "
                + " boolean " + " BOOLEAN "
                + " var " + " VARIABLE "
                + " const " + " CONSTANTE "
                + " ; " + " PUNTOYCOMA "
                + " := " + " ASIGNACION "
                + " <= " + " MAYORIGUALQUE "
                + " >= " + " MENORIGUALQUE "
                + " < " + " MENORQUE "
                + " > " + " MAYORQUE "
                + " = " + " IGUAL "
                + " <> " + " DISTINTODE "
                + " + " + " COMA "
                + " and " + " Y "
                + " or " + " O "
                + " not " + " NEGACION "
                + " if " + " IF "
                + " repeat " + " REPEAT "
                + " until " + " UNTIL "
                + " then " + " THEN "
                + " begin " + " BEGIN "
                + " end " + " END "
                + " else " + " ELSE "
                + " for " + " FOR "
                + " to " + " TO "
                + " do " + " DO "
                + " while " + " WHILE "
                + " Procedure " + " PROCEDURE "
                + " function " + " FUNCTION "
                + "  " + " PARENTESISIZQ "
                + "  " + " PARENTESISDER "
                + " : " + " DOSPUNTOS "
                + " + " + " SUMA "
                + " * " + " MULTIPLICACION "
                + " - " + " RESTA "
                + " / " + " DIVISION "
                + " mod " + " MODULO ";

        try {
            File archivo2 = new File("TablaEstatica.txt");
            try (FileWriter escribir2 = new FileWriter(archivo2, false)) {
                escribir2.write(TSEstatica + System.getProperty("line.separator"));
            }
        } catch (Exception e) {
        }
        try {
            File archivo3 = new File("salida.txt");
            try (FileWriter escribir2 = new FileWriter(archivo3, false)) {

                // escribir2.write(area3.getText());
            }
        } catch (Exception e) {
        }
    }

}
