// Liveness test: "check passed"
// This is a simplest sample demonstrating liveness checking
// by Zing

event UserEvent;
event Done;
event Waiting;
event Computing;

main machine EventHandler
{
       start state WaitForUser
       {
            entry { 
				new WatchDog();
				monitor WatchDog, Waiting;
				send this, UserEvent;
				}
            on UserEvent goto HandleEvent;
       }
  
       state HandleEvent
       {
            entry { 
				monitor WatchDog, Computing;
				send this, Done;
				}			
            on Done goto WaitForUser;
       }
}

monitor WatchDog
{
      start cold state CanGetUserInput
      {
             on Waiting goto CanGetUserInput;
             on Computing goto CannotGetUserInput;
      } 
	  hot state CannotGetUserInput
     {
             on Waiting goto CanGetUserInput;
             on Computing goto CannotGetUserInput;
     }
}
