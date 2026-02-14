using System;
using System.Collections.Generic;
using Unity.Collections;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;
using Debug = UnityEngine.Debug;

public enum BoostStates
{
    Gear1,
    Gear2,
    Gear3,
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

    public PlayerPresets(float groundSpeed, float airSpeed, float jumpForce, float gravityForce,float timerMult)
    {
        this.groundSpeed = groundSpeed;
        this.airSpeed = airSpeed;
        this.jumpForce = jumpForce;
        this.gravityForce = gravityForce;
        this.timerMult = timerMult;
    }
    
    public static PlayerPresets Slow = new(5f, 5f, 3.5f, 1.5f,0.5f);
    public static PlayerPresets Mid = new(15f, 10f, 15f, 17f,1f);
    public static PlayerPresets Swift = new(17f, 15f, 20f, 22f,1.5f);
}

public class PlayerBoost : MonoBehaviour
{
    [Header("References")]
    private CustomInputs playerControls;
    private PlayerTimer timerController;
    public Material mat;

    [Header("Debug Values")]
    public float DEBUG_groundSpeed;
    public float DEBUG_airSpeed;
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
            case BoostStates.Gear1:
                preset = PlayerPresets.Slow;
                mat.color = new Color(0f, 0f, 1f);
                break;
                
            case BoostStates.Gear2:
                preset = PlayerPresets.Mid;
                mat.color = new Color(0f, 1f, 1f);
                break;
                
            case BoostStates.Gear3:
                preset = PlayerPresets.Swift;
                mat.color = new Color(1f, 1f, 0f);
                break;

            case BoostStates.DEBUG:
                mat.color = Color.white;
                break;
        }
        
        Debug.Log(preset.groundSpeed);
        return preset;
    }
}
