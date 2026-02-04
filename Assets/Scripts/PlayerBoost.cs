using System.Collections.Generic;using UnityEngine;
using UnityEngine.InputSystem;
public enum BoostStates
{
    SuperSlow,
    Slow,
    Base,
    Swift,
    SuperSwift
}

// public class Stats(float, int)
// {
//     public static List<Stats>(float test, int test2);
// }

public class PlayerBoost : MonoBehaviour
{
    [Header("References")]
    private PlayerController playerController;
    private CustomInputs playerControls;
    private PlayerTimer timerController;
    
    [Header("Stats")]
    public float groundSpeedBonus;
    public float airSpeedBonus;
    public float jumpForceBonus;

    [Header("Player Boosts")]
    public float timerMult;
    
    public BoostStates boostStates;
    public float boostTimerMult;
    
    void Start()
    {
        playerController = GetComponent<PlayerController>();
        timerController = GetComponent<PlayerTimer>();
        playerControls = playerController.playerControls;
        TimerAlterator();
    }
    
    void Update()
    {
        if (playerControls.Player.Upgrade.WasPressedThisFrame())
            boostStates += 1;

        if (playerControls.Player.Downgrade.WasPressedThisFrame())
            boostStates -= 1;
        
        switch (boostStates)
        {
            case BoostStates.SuperSlow:
                
                break;
                
            case BoostStates.Slow:
                
                break;
                
            case BoostStates.Base:
                
                break;
                
            case BoostStates.Swift:
                
                break;
                
            case BoostStates.SuperSwift:
                
                break;
        }
    }
    
    void TimerAlterator()
    {
        timerMult = 1f * boostTimerMult;
        Debug.Log("Speed Boost = " + timerMult);
    }
}
