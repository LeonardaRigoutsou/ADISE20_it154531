# ADISE20_it154531 - ΣΚΟΡ4

<b>Connect Four Game - Πληροφορίες παιχνιδιού </b>

<p>Το Σκορ 4 είναι ένα παιχνίδι στρατηγικής το οποίο παίζεται με 2 παίκτες</p>
<p>Αποτελείται από ένα ταμπλό διαστάσεων 7x6. Κάθε παίκτης έχει στην διάθεσή του 21 πιόνια, τα οποία τοποθετούνται σε οποιαδήποτε στήλη από την κορυφή και ολισθαίνουν προς τα κάτω.</p>

<p>Νικητής του παιχνιδιού είναι αυτός που θα συμπληρώσει πρώτος μία σειρά από 4 μάρκες ίδιου χρώματος προς οποιαδήποτε κατεύθυνση (οριζόντια, κάθετα ή διαγώνια)</p>

<hr>
<h2>Εγκατάσταση: </h2>
<br>
<b>Απαιτήσεις:</b>
<ul>
  <li>Apache2</li>
  <li>MySQL Server</li>
  <li>php</li>
</ul>
  
<hr>

<h2>Link for POSTMAN: </h2>
https://users.iee.ihu.gr/~it154531/

<h3>Περιγραφή του Project μου: </h3>
<p>Το παιχνίδι τηρεί όλους τους παραπάνω κανόνες και υλοποιήθηκε με PHP και MySql για human-human, χωρίς GUI (μέσω POSTMAN).</p>
<p>Αρχικά πρέπει να γίνει η αρχικοποίηση της σύνδεσης. Το authentication γίνεται χωρίς password.</p>
<p>Όλη η κατάσταση του παιχνιδιού αποθηκεύεται πλήρως σε mysql. Μεγάλο μέρος της λειτουργικότητας γίνεται με διάφορες procedures στην mysql οι οποίες  καλούνται μέσω του WebAPI</p>
<p>Το API αποτελείται από: </p>
<ul>
  <li>dbconnect</li>  -->Για σύνδεση στην βάση
  <li>connect_user</li> --> Για σύνδεση του παίκτη στο παιχνίδι 
  <li>players_movement</li> --> Για εκτέλεση κίνησης από τον παίκτη 
  <li>show_board</li> --> Επιστροφή της κατάστασης του board
  <li>aborded</li> --> Για έλεγχο σε περίπτωση που βγει ένας παίκτης
  <li>clean_board</li>  --> Για εκκαθάριση του board
</ul>

<h3>Πίνακες στην βάση:</h3>
<h4>board</h4>
<table border: 1px solid black>
<tr>
  <th>Attribute</th>
  <th>Description</th>
  <th>Values</th>
 </tr>
 <tr>
   <td>x</td>
   <td>Η συντεταγμένη x του πίνακα (στήλες)</td>
   <td>1-7</td>
  </tr>
 <tr>
   <td>y</td>
   <td>Η συντεταγμένη y του πίνακα (γραμμές)</td>
   <td>1-6</td>
 </tr>
 <tr>
   <td>color</td>
   <td>Χρώμα της μάρκας</td>
   <td>R ή Β (Red or Blue)</td>
 </tr>
 <tr>
   <td>id</td>
   <td>Αύξων αριθμός της κάθε εγγραφής</td>
   <td>1...τελευταίο αριθμό κινήσεων που καταγράφηκαν στο board</td>
 </tr>
 </table>
 
<h4>game_status</h4>
<table border: 1px solid black>
<tr>
  <th>Attribute</th>
  <th>Description</th>
  <th>Values</th>
 </tr>
 <tr>
   <td>status</td>
   <td>Κατάσταση παιχνιδιού</td>
   <td>'not active', 'initialized', 'started', 'ended', 'aborded'</td>
  </tr>
 <tr>
   <td>p_turn</td>
   <td>Το χρώμα του παίκτη που παίζει</td>
   <td>'R','B'</td>
 </tr>
 <tr>
   <td>result</td>
   <td>Το χρώμα του παίκτη που κέρδισε</td>
   <td>R ή Β ή D (Red ή Blue ή Draw)</td>
 </tr>
 <tr>
   <td>last_change</td>
   <td>Τελευταία αλλαγή/ενέργεια στην κατάσταση του παιχνιδιού</td>
   <td>timestamp</td>
 </tr>
 </table>
 
<h4>players</h4>
<table border: 1px solid black>
<tr>
  <th>Attribute</th>
  <th>Description</th>
  <th>Values</th>
 </tr>
 <tr>
   <td>username</td>
   <td>Όνομα παίκτη</td>
   <td>String</td>
  </tr>
 <tr>
   <td>color</td>
   <td>To χρώμα που παίζει ο παίκτης</td>
   <td>'R','B'</td>
 </tr>
 <tr>
   <td>id</td>
   <td>Αύξων αριθμός της κάθε εγγραφής</td>
   <td>1...όσοι παίκτες έχουν δημιουργηθεί συνολικά στα παιχνίδια</td>
 </tr>
 <tr>
   <td>token</td>
   <td>To κρυφό token του παίκτη. Επιστρέφεται μόνο τη στιγμή της εισόδου του παίκτη στο παιχνίδι</td>
   <td>HEX</td>
 </tr>
 </table>
 
 <h2>Procedures στην MySql</h2>
 <ul>
  <li>check_winner</li> --> Καλείται στο τέλος της συνάρτησης "players_movement" για τις συνθήκες νίκης 
  <li>clean_board</li> --> Υπεύθυνη για τον καθαρισμό των πινάκων για να επαναφέρει τον board στην αρχική κατάσταση
  <li>players_movement</li> --> Υπεύθυνη για τις επιτρεπόμενες κινήσεις του παίκτη (κάνοντας όλους τους απαραίτητους ελέγχους)
 
