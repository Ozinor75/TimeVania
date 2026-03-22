using UnityEngine;

public class PlayerSound : MonoBehaviour
{
    [Header("Cooldowns")] 
    public float footStepCooldown;
    
    [Header("Prefabs")] 
    public AudioSource[] footSteps;
    public AudioSource[] jump;
    public AudioSource[] dash;
    public AudioSource slow;
    public AudioSource swift;
    public AudioSource start;
    public AudioSource stop;
    public AudioSource reload;
    public AudioSource[] hurt;
    
    private PlayerController player;
    private float t = 0f;

    public void HurtSound()
    {
        hurt[Random.Range(0, hurt.Length)].Play();
    }
    public void Reload()
    {
        reload.Play();
    }
    
    public void StartSound()
    {
        start.Play();
    }
    public void StopSound()
    {
        stop.Play();
    }
    public void Mid()
    {
        slow.Stop();
        swift.Stop();
    }
    public void Slow()
    {
        slow.Play();
    }
    
    public void Swift()
    {
        swift.Play();
    }
    
    public void Dash()
    {
        dash[Random.Range(0, dash.Length)].Play();
    }
    
    public void Jump()
    {
        jump[Random.Range(0, jump.Length)].Play();
    }
    public void FootSteps()
    {
        int i = Random.Range(0, footSteps.Length);
        footSteps[i].Play();
    }
    void Start()
    {
        player = transform.parent.GetComponent<PlayerController>();
    }
    void Update()
    {
        if (player.isGrounded)
            if (player.rb.linearVelocityX > 0.05f || player.rb.linearVelocityX < -0.05f)
                t += Time.deltaTime;
        if (t >= footStepCooldown)
        {
            FootSteps();
            t = 0f;
        }
    }
}
