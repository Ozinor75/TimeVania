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
    Gear4,
    Gear5
}

public class PlayerPresets
{
    [Header("Stats")]
    public float groundSpeed;
    public float airSpeed;
    public float jumpForce;
    public float timerMult;

    public PlayerPresets(float groundSpeed, float airSpeed, float jumpForce, float timerMult)
    {
        this.groundSpeed = groundSpeed;
        this.airSpeed = airSpeed;
        this.jumpForce = jumpForce;
        this.timerMult = timerMult;
    }
    
    public static PlayerPresets SuperSlow = new(1f, 1f, 1f, 1f);
    public static PlayerPresets Slow = new(5f, 5f, 5f, 5f);
    public static PlayerPresets Mid = new(10f, 10f, 10f, 10f);
    public static PlayerPresets Swift = new(20f, 20f, 20f, 20f);
    public static PlayerPresets SuperSwift = new(50f, 50f, 50f, 50f);
}

public class PlayerBoost : MonoBehaviour
{
    [Header("References")]
    private CustomInputs playerControls;
    private PlayerTimer timerController;
    public Material mat;
    
    public BoostStates boostState;
    private PlayerController playerController;
    public float totalTimerMult;
    
    void Start()
    {
        timerController = GetComponent<PlayerTimer>();
    }

    public PlayerPresets ReturnGearSpeed()
    { 
        PlayerPresets preset = PlayerPresets.SuperSlow;

        switch (boostState)
        {
            case BoostStates.Gear1:
                preset = PlayerPresets.SuperSlow;
                mat.color = new Color(0f, 0f, 1f);
                break;
                
            case BoostStates.Gear2:
                preset = PlayerPresets.Slow;
                mat.color = new Color(0f, 1f, 1f);
                break;
                
            case BoostStates.Gear3:
                preset = PlayerPresets.Mid;
                mat.color = new Color(0f, 1f, 0f);
                break;
                
            case BoostStates.Gear4:
                preset = PlayerPresets.Swift;
                mat.color = new Color(1f, 1f, 0f);
                break;
                
            case BoostStates.Gear5:
                preset = PlayerPresets.SuperSwift;
                mat.color = new Color(1f, 0f, 0f);
                break;
        }
        
        Debug.Log(preset.groundSpeed);
        return preset;
    }
}
