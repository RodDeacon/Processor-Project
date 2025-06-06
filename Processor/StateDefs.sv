// PACKAGE FILE TO SUPPORT THE STATEMACHINE 

package StateDefs;
   // State enumeration for the control unit
   typedef enum logic [3:0] { 
      Noop = 0,   // 0  NOOP
      Store = 1,  // 1 STORE
      Load_A = 2, // 2.1 LOAD
      Add = 3,    // 3 ADD
      Sub = 4,    // 4 SUB
      Halt = 5,   // 5 HALT
      Load_B,     // 6 LOAD
      Init,       // 7 Init
      Fetch,      // 8 Fetch
      Decode      // 9 Decode
   } State;
// instruction enumeration for the control unit
   typedef enum logic [3:0] { 
      _noop = 0,  // 0  NOOP
      _store,     // 1 STORE
      _load,      // 2 LOAD
      _add,       // 3 ADD
      _sub,       // 4 SUB
      _halt       // 5 HALT
   } inst;


   // functions
// function to convert the State enumeration to a string 
   function string state_to_string(State s);
      case (s)
         Noop:     return "Noop";
         Store:    return "Store";
         Load_A:   return "Load_A";
         Load_B:   return "Load_B";
         Add:      return "Add";
         Sub:      return "Sub";
         Halt:     return "Halt";
         Init:     return "Init";
         Fetch:    return "Fetch";
         Decode:   return "Decode";
         default:  return "Unknown";
      endcase
   endfunction

// function to convert the instruction enumeration to a string
   function string inst_to_string(inst instruction);
      case (instruction)
         _noop  : return "Noop";
         _store : return "Store";
         _load  : return "Load_A";
         _add   : return "Add";
         _sub   : return "Sub";
         _halt  : return "Halt";
         default: return "Unknown";
      endcase
   endfunction

endpackage