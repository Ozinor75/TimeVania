using UnityEngine;
using UnityEngine.InputSystem;
public enum BoostStates
{
    speed,
    jump,
    gravity
}

public class PlayerBoost : MonoBehaviour
{
    [Header("References")]
    private PlayerController playerController;
    private CustomInputs playerControls;
    private PlayerTimer timerController;
    
    [Header("Stats")]
    public float groundSpeedBonus;
    private float groundSpeedBase;
    
    public float airSpeedBonus;
    private float airSpeedBase;
    
    public float jumpForceBonus;
    private float jumpForceBase;

    [Header("Player Boosts")]
    public float timerMult;
    
    public bool isBoosted;
    public float boostTimerMult;
    
    void Start()
    {
        playerController = GetComponent<PlayerController>();
        timerController = GetComponent<PlayerTimer>();
        playerControls = playerController.playerControls;
        
        groundSpeedBase = playerController.groundSpeed;
        airSpeedBase = playerController.airSpeed;
        jumpForceBase = playerController.jumpForce;
        
        TimerAlterator();
    }
    
    void Update()
    {
        if (playerControls.Player.SpeedBoost.WasPressedThisFrame())
        {
            if (!isBoosted)
            {
                // Debug.Log("SPEED BOOST !");
                playerController.groundSpeed = groundSpeedBonus;
                isBoosted = true;
                TimerAlterator();
            }
            else
            {
                // Debug.Log("SPEED BOOST STOP !");
                playerController.groundSpeed = groundSpeedBase;
                isBoosted = false;
                TimerAlterator();
            }
            
        }
        
        // if (playerControls.Player.JumpBoost.WasPressedThisFrame())
        // {
        //     if (!isJumpBoosted)
        //     {
        //         // Debug.Log("JUMP BOOST !");
        //         playerController.jumpForce = jumpForceBonus;
        //         playerController.airSpeed = airSpeedBonus;
        //         isJumpBoosted = true;
        //         TimerAlterator();
        //     }
        //     else
        //     {
        //         // Debug.Log("JUMP BOOST !");
        //         playerController.jumpForce = jumpForceBase;
        //         playerController.airSpeed = airSpeedBase;
        //         isJumpBoosted = false;
        //         TimerAlterator();
        //     }
        //     
        // }
    }
    
    void TimerAlterator()
    {
        timerMult = 1f;

        if (isBoosted)
            timerMult *= boostTimerMult;
        if (isJumpBoosted)
            timerMult *= jumpBoostMult;
        
        Debug.Log("Speed Boost = " + timerMult);
    }
}
