// PACKAGE FILE TO SUPPORT THE STATEMACHINE 

package StateDefs;

typedef enum logic [3:0] { 
   Noop = 0,   // 0  NOOP
   Store = 1,  // 1 STORE
   Load_A = 2, // 2.1 LOAD
   Add = 3,    // 3 ADD
   Sub = 4,    // 4 SUB
   Halt = 5,   // 5 HALT
   Load_B,     // 2.1 LOAD
   Init,       // 6 Init
   Fetch,      // 7 Fetch
   Decode      // 8 Decode
 } State;

 typedef enum logic [3:0] { 
   _noop = 0,  // 0  NOOP
   _store,     // 1 STORE
   _load,      // 2 LOAD
   _add,       // 3 ADD
   _sub,       // 4 SUB
   _halt       // 5 HALT
 } inst;

endpackage