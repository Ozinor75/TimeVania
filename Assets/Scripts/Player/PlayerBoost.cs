using System;
using System.Collections.Generic;
using Unity.Collections;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;
using Debug = UnityEngine.Debug;

public class PlayerBoost : MonoBehaviour
{
    [Header("References")]
    // private CustomInputs playerControls;
    // private PlayerTimer timerController;

    [Header("RGD Values")]
    public float groundSpeed;
    public float airSpeed;
    public float jumpForce;
    public float dashDistance;
    public float boostedConsumptionMult;
    public float baseConsumptionMult;
    
    // private PlayerController playerController;
    
    // void Start()
    // {
    //     // timerController = GetComponent<PlayerTimer>();
    // }
}
