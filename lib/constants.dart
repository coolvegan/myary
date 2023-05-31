const securityKey = "Y#6DQ(FK#dqMrJ!WxFZW?m4Syfy}GF-&";
const appwriteEndpoint = "https://backend.kittel.dev/v1";
const appwriteProjectId = "6458e0cecaf272bb435d";
const appwriteDatabaseId = "6458e13ec93ef65939fb";
const appwriteCollectionId = "6458e14b8f030fb4773d";
const appwriteCollectionHappyDiary = "6470a89405986af6a531";
const appwriteSelfSigned = false;

const sharedPrefUserdataKey = "userdata";
const textCreateTodo = "Todo Erstellen";
const textCreateHappyDiary = "Schönes Ereignis Eintragen";
const textAppTitle = "Todolist";
const textAppHappyDiary = "Glückstagebuch";
const textOpenTodos = "Offene Todos";
const textCompletedTodos = "Fertige Todos";
const textNewTodo = "Neue Todo";
const textNewHappyDiaryEntry = "Neuer Eintrag";
const textTodoDlgHint = "Deine Todo";
const textHappyDlgHint = "Dein Happydiary Eintrag";
const textCancel = "Abbrechen";
const textOkay = "Ok";
const textLogin = "Login";
const textDateHappyness = "Geschrieben am: ";
const textDeleteTodo = "Was soll mit der Todo passieren?";
const textUpdateTodo = "Todo bearbeiten";
const textUpdateHappynessDiary = "Todo bearbeiten";
const textEnterEmail = "Bitte Email Adresse eingeben";
const textTodoUntilFinished = "Wie oft willst du die Todo ausführen?";

//execute setupenv.sh to set $MYARY_SECRET Environment Variable
abstract class Constants {
  static const String securityKey = String.fromEnvironment(
    'MYARY_SECRET',
    defaultValue: '',
  );
}
