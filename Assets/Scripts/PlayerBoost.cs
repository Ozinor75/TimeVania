using UnityEngine;
using UnityEngine.InputSystem;

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
    public float speedBoostTimer;
    public float speedBoostT;
    public bool isSpeedBoosted;
    
    public float jumpBoostTimer;
    public float jumpBoostT;
    public bool isJumpBoosted;
    
    void Start()
    {
        playerController = GetComponent<PlayerController>();
        timerController = GetComponent<PlayerTimer>();
        playerControls = playerController.playerControls;
        
        
        groundSpeedBase = playerController.groundSpeed;
        airSpeedBase = playerController.airSpeed;
        jumpForceBase = playerController.jumpForce;
    }
    
    void Update()
    {
        BoostTimerEffect();
        
        if (playerControls.Player.SpeedBoost.WasPressedThisFrame())
        {
            Debug.Log("SPEED BOOST !");             // ACCELERATE TIME
            timerController.t -= speedBoostTimer;   // remove time to timer
            speedBoostT = speedBoostTimer;          // reset boost timeer
            playerController.groundSpeed += groundSpeedBonus;                       // apply boost
            isSpeedBoosted = true;                  // apply boost bool
        }
        
        if (playerControls.Player.JumpBoost.WasPressedThisFrame())
        {
            Debug.Log("JUMP BOOST !");
            timerController.t -= jumpBoostTimer;
            jumpBoostT = jumpBoostTimer;
            playerController.jumpForce += jumpForceBonus;
            playerController.airSpeed += airSpeedBonus;
            isJumpBoosted = true;
        }
    }
    
    void BoostTimerEffect()
    {
        if (isSpeedBoosted)
        {
            speedBoostT -= Time.deltaTime;
            if (speedBoostT <= 0f)
            {
                playerController.groundSpeed = groundSpeedBase;
                isSpeedBoosted = false;
            }
        }
        
        if (isJumpBoosted)
        {
            jumpBoostT -= Time.deltaTime;
            if (jumpBoostT <= 0f)
            {
                playerController.jumpForce = jumpForceBase;
                playerController.airSpeed = airSpeedBase;
                isJumpBoosted = false;
            }
        }
    }
}
