using System;
using System.Collections.Generic;
using Unity.Collections;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;
using Debug = UnityEngine.Debug;

public enum BoostStates
{
    LowEnergy,
    BaseMode,
    Boost,
    SuperBoost,
    DEBUG
}

public class PlayerPresets
{
    [Header("Stats")]
    public float vMax;
    public float groundSpeed;
    public float airSpeed;
    public float dashSpeed;
    public float dashDuration;
    public float jumpForce;
    public float gravityForce;
    public float timerMult;

    public PlayerPresets(float groundSpeed, float airSpeed, float dashSpeed, float dashDuration, float jumpForce, float gravityForce,float timerMult)
    {
        this.groundSpeed = groundSpeed;
        this.airSpeed = airSpeed;
        this.dashSpeed = dashSpeed;
        this.dashDuration = dashDuration;
        this.jumpForce = jumpForce;
        this.gravityForce = gravityForce;
        this.timerMult = timerMult;
    }
    
    public static PlayerPresets Slow = new(6f, 3f, 20f, 0.2f,7f, 5f,0.5f);
    public static PlayerPresets Mid = new(9f, 5f, 20f, 0.2f,12f, 10f,1f);
    public static PlayerPresets Swift = new(14f, 8f, 20f, 0.2f, 17f, 15f,2f);
    public static PlayerPresets SuperSwift = new(22f, 10f, 20f, 0.2f, 22f, 20f,5f);
}

public class PlayerBoost : MonoBehaviour
{
    [Header("References")]
    private CustomInputs playerControls;
    private PlayerTimer timerController;
    public Material mat;

    [Header("Debug Values")]
    public float DEBUG_groundForce;
    public float DEBUG_airForce;
    public float DEBUG_dashForce;
    public float DEBUG_dashDuration;
    public float DEBUG_jumpForce;
    public float DEBUG_gravityForce;
    public float DEBUG_timerMult;
    
    public BoostStates boostState;
    private PlayerController playerController;
    public float totalTimerMult;
    
    void Start()
    {
        timerController = GetComponent<PlayerTimer>();
    }

    public PlayerPresets ReturnGearSpeed()
    { 
        PlayerPresets preset = PlayerPresets.Slow;

        switch (boostState)
        {
            case BoostStates.LowEnergy:
                preset = PlayerPresets.Slow;
                mat.color = new Color(0f, 0f, 1f);
                break;
                
            case BoostStates.BaseMode:
                preset = PlayerPresets.Mid;
                mat.color = new Color(0f, 1f, 1f);
                break;
                
            case BoostStates.Boost:
                preset = PlayerPresets.Swift;
                mat.color = new Color(1f, 1f, 0f);
                break;
                
            case BoostStates.SuperBoost:
                preset = PlayerPresets.SuperSwift;
                mat.color = new Color(1f, 0f, 0f);
                break;
            case BoostStates.DEBUG:
                preset = new PlayerPresets(/*DEBUG_vMax,*/ DEBUG_groundForce,
                                            DEBUG_airForce, DEBUG_dashForce, DEBUG_dashDuration, DEBUG_jumpForce,
                                            DEBUG_gravityForce, DEBUG_timerMult);
                mat.color = Color.white;
                break;
        }
        
        Debug.Log(preset.groundSpeed);
        return preset;
    }
}
