using System;
using UnityEngine;
using UnityEngine.Events;

public class WorldEvents : MonoBehaviour
{
    public GameObject player;
    public UnityEvent platformDestroyed;
    public UnityEvent missileDestroyed;

    private void Start()
    {
        player = FindFirstObjectByType<PlayerController>().gameObject;
    }


}
